require("dotenv").config();
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const stripe = require("stripe")(functions.config().stripe.secret);
const {Configuration, PlaidApi, PlaidEnvironments} = require("plaid");
const express = require("express");
const app = express();
app.use(express.json());

const PLAID_REDIRECT_URI = process.env.PLAID_REDIRECT_URI || "";
const PLAID_ANDROID_PACKAGE_NAME =
 process.env.PLAID_ANDROID_PACKAGE_NAME || "com.mooweapp.mooweapp";
const PLAID_CLIENT_ID = process.env.PLAID_CLIENT_ID;
const PLAID_SECRET = process.env.PLAID_SECRET;
const PLAID_PRODUCTS = process.env.PLAID_PRODUCTS;
const MTN_COLLECTION_PRIMARY_KEY = process.env.COLLECTION_PRIMARY_KEY;
const MTN_COLLECTION_SECONDARY_KEY = process.env.COLLECTION_SECONDARY_KEY;
const MTN_DISBURSMENT_PRIMARY_KEY = process.env.DISBURSMENT_PRIMARY_KEY;
const MTN_DISBURSMENT_SECONDARY_KEY = process.env.DISBURSMENT_SECONDARY_KEY;
const MTN_REMITTANCE_PRIMARY_KEY = process.env.REMITTANCE_PRIMARY_KEY;
const MTN_REMITTANCE_SECONDARY_KEY = process.env.REMITTANCE_SECONDARY_KEY;

const configuration = new Configuration({
  basePath: PlaidEnvironments[process.env.PLAID_ENV],
  baseOptions: {
    headers: {
      "PLAID-CLIENT-ID": PLAID_CLIENT_ID,
      "PLAID-SECRET": PLAID_SECRET,
      "Plaid-Version": "2020-09-14",
    },
  },
});

const client = new PlaidApi(configuration);

exports.addMessage = functions.https.onRequest(
    async (req, res) => {
      // Grab the text parameter.
      const original = req.query.text;
      // Push the new message into Firestore using the Firebase Admin SDK.
      const writeResult = await admin.firestore().collection("messages").add(
          {original: original});
      // Send back a message that we've successfully written the message
      res.json({result: "Message with ID: "+ writeResult.id + " added."});
    });

exports.stripePayment = functions.https.onRequest(
    async (req, res) =>{
      await stripe.paymentIntents.create({
        amount: req.body.amount,
        currency: req.body.currency,
        off_session: false,
        confirm: true,
        confirmation_method: "manual",
      },
      function(err, paymentIntent) {
        if (err != null) {
          console.log(err);
        } else {
          res.json({
            paymentIntent: paymentIntent.client_secret,
          });
        }
      });
    });

exports.savePaymentMethod = functions.https.onRequest(
    async (req, res) => {
      try {
        const customerList = await stripe.customers.list({
          email: req.body.email,
          limit: 1,
        });
        if (customerList.data.length == 0) {
          const customer = await stripe.customers.create({
            email: req.body.email,
            source: req.body.token,
          });
          res.status(200).send({
            customer: customer,
            success: true,
          });
        } else {
          const customer = await stripe.customers.update(
              customerList.data[0].id,
              {source: req.body.token},
          );
          res.status(200).send({
            customer: customer,
            message: "stripe custmer already exists",
            success: true,
          });
        }
      } catch (error) {
        res.status(404).send({success: false, error: error.message});
      }
    });

exports.chargeSource = functions.https.onRequest(
    async (req, res) => {
      try {
        const charge = await stripe.charges.create({
          amount: req.body.amount,
          currency: req.body.currency,
          customer: req.body.customer,
          source: req.body.source,
        });
        res.status(200).send({
          charge: charge,
          success: true,
        });
      } catch (error) {
        res.status(404).send({success: false, error: error.message});
      }
    });

exports.stripePaymentIntentRequest = functions.https.onRequest(
    async (req, res) => {
      try {
        let customerId;
        // Gets the customer who's email id matches the one sent by the client
        const customerList = await stripe.customers.list({
          email: req.body.email,
          limit: 1,
        });
          // Checks the if the customer exists, if not creates a new customer
        if (customerList.data.length !== 0) {
          customerId = customerList.data[0].id;
        } else {
          const customer = await stripe.customers.create({
            email: req.body.email,
          });
          await stripe.setupIntents.create({
            customer: customer.data.id,
          });
          customerId = customer.data.id;
        }
        // Creates a temporary secret key linked with the customer
        const ephemeralKey = await stripe.ephemeralKeys.create(
            {customer: customerId},
            {apiVersion: "2020-08-27"},
        );
        // Creates a new payment intent with amount passed in from the client
        const paymentIntent = await stripe.paymentIntents.create({
          amount: parseInt(req.body.amount),
          currency: req.body.currency,
          confirm: true,
          customer: customerId,
          payment_method: req.body.payment_method_Id,
          statement_descriptor: "mowe",
          setup_future_usage: "off_session",
        });
        res.status(200).send({
          paymentIntent: paymentIntent,
          client_secret: paymentIntent.client_secret,
          ephemeralKey: ephemeralKey.secret,
          customer: customerId,
          success: true,
        });
      } catch (error) {
        res.status(404).send({success: false, error: error.message});
      }
    });

exports.confirmPayment = functions.https.onRequest(
    async (req, res) => {
      try {
        const payment = await stripe.paymentIntents.confirm(
            req.body.paymentIntentId,
            req.body.payment_method,
        );
        res.status(200).send({
          payment: payment,
          success: true,
        });
      } catch (error) {
        res.status(404).send({success: false, error: error.message});
      }
    });

exports.cleanupUser = functions.auth.user().onDelete(async (user) => {
  const dbRef = admin.firestore().collection("stripe_customers");
  const customer = (await dbRef.doc(user.uid).get()).data();
  await stripe.customers.del(customer.customer_id);
  // Delete the customers payments & payment methods in firestore.
  const batch = admin.firestore().batch();
  const paymetsMethodsSnapshot = await dbRef
      .doc(user.uid)
      .collection("payment_methods")
      .get();
  paymetsMethodsSnapshot.forEach((snap) => batch.delete(snap.ref));
  const paymentsSnapshot = await dbRef
      .doc(user.uid)
      .collection("payments")
      .get();
  paymentsSnapshot.forEach((snap) => batch.delete(snap.ref));
  await batch.commit();
  await dbRef.doc(user.uid).delete();
  return;
});

exports.getPlaidLinkTokenCreate = functions.https.onRequest(
    async (req, res) => {
      try {
        const configs = {user: {
          client_user_id: req.body.uid,
        },
        client_name: "Plaid Quickstart",
        products: PLAID_PRODUCTS,
        country_codes: ["US"],
        language: "en",
        };
        if (PLAID_REDIRECT_URI !== "") {
          configs.redirect_uri = PLAID_REDIRECT_URI;
        }
        if (PLAID_ANDROID_PACKAGE_NAME !== "") {
          configs.android_package_name = PLAID_ANDROID_PACKAGE_NAME;
        }
        const createTokenResponse = await client.linkTokenCreate(configs);
        res.status(200).send({
          lkinkToken: createTokenResponse.data,
          success: true,
        });
      } catch (error) {
        res.status(404).send({success: false, error: error.message});
      }
    },
);

exports.getApiKeys = functions.https.onRequest(
    async (req, res) => {
      try {
        res.status(200).send({
          plaidClientId: PLAID_CLIENT_ID,
          plaidSecret: PLAID_SECRET,
          serverToken: process.env.SERVER_TOKEN,
          googleMapApiKey: process.env.GOOGLE_MAP_API_KEY,
          mtnCollectionPrimaryKey: MTN_COLLECTION_PRIMARY_KEY,
          mtnCollectionSecondaryKey: MTN_COLLECTION_SECONDARY_KEY,
          mtnDisbursementsPrimaryKey: MTN_DISBURSMENT_PRIMARY_KEY,
          mtnDisbursementsSecondaryKey: MTN_DISBURSMENT_SECONDARY_KEY,
          mtnRemittancePrimaryKey: MTN_REMITTANCE_PRIMARY_KEY,
          mtnRemittanceSecondaryKey: MTN_REMITTANCE_SECONDARY_KEY,
          success: true,
        });
      } catch (error) {
        res.status(404).send({success: false, error: error.message});
      }
    },
);
