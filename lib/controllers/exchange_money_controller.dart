import 'package:mooweapp/export_files.dart';

class ExchangeMoneyController extends GetxController {
  static ExchangeMoneyController instance = Get.find();

  RxDouble receiveRate = RxDouble(0.0);
  RxDouble exchangeRate = RxDouble(0.0);
  RxDouble moweExchangeRate = RxDouble(0.0);
  RxDouble moweReceiveRate = RxDouble(0.0);
  RxDouble moweTotalProfit = RxDouble(0.0);
  RxDouble moweProfitOnExchangeRate = RxDouble(0.0);
  RxDouble amountToBeExchange = RxDouble(0.0);

  RxString exchangeFrom = RxString("");
  RxString exchangeTo = RxString("");
  DocumentReference? exchangeReference;
  DocumentSnapshot? serviceChargesSnap;
  RxDouble instantCashOutTransactionAmount = RxDouble(0.0);
  RxDouble instantCashOutCharge = RxDouble(0.0);
  RxBool exchangeSuccess = RxBool(false);
  @override
  void onReady() {
    ever(amountToBeExchange, (callback) async {
      getServiceCharges();

      if (amountToBeExchange.value > 0.0) {
        transactionService.data = await currencyExchangeConverter();
      }
    });

    // ever(cart, (callback) => checkOutOrder());
    super.onReady();
  }

  void getServiceCharges() {
    firebaseFirestore.collection("serviceCharges").doc("D1D0jx2xqs1MmRHD9LQO").snapshots().listen((DocumentSnapshot snapshot) {
      serviceChargesSnap = snapshot;
      affiliateMarkDownPercent.value = serviceChargesSnap!.get("affiliateMarkDownPercent").toDouble();
      exchangeMarkDownPercent.value = serviceChargesSnap!.get("exchangeMarkDownPercent").toDouble();
      // print(serviceChargesSnap!.data());
    });
  }

  Future<Map<String, dynamic>> currencyExchangeConverter() async {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}

    var client = Client();
    // https://www.currencyconverterapi.com/dev;

    //apiKey:24cbc3faa76a763d73c0
    //apiKey:05cad5bc31ca4aa4a8354b760818580e
    var uriResponse = await client.get(
      Uri.parse('https://free.currconv.com/api/v7/convert?q=${transactionService.localCurrency}_${transactionService.remoteCurrency},'
          '${transactionService.remoteCurrency}_${transactionService.localCurrency}&compact=y&apiKey=05cad5bc31ca4aa4a8354b760818580e'),
    );

    if (uriResponse.statusCode == 200) {
      exchangeSuccess.value = true;
      Map<String, dynamic> data = await json.decode(uriResponse.body);
      print("currency data");
      print(data);
      print(data.keys.last);
      print(data[data.keys.last]);
      print(data[data.keys.last]["val"]);
      print(data[data.keys.first]["val"]);

      // Map<String, dynamic> rec_user =await data["${widget.contactCurrency}_${widget.userCurrency}"];
      Map<String, dynamic> uerRec = await data["${transactionService.localCurrency}_${transactionService.remoteCurrency}"];
      // print("uerRec");
      // print(uerRec);
      exchangeRate.value = double.parse(uerRec.values.first.toString());
      receiveRate.value = (double.parse(uerRec.values.first.toString()) * transactionService.transactionAmount.value);

      exchangeCharges();
      return {
        "data": data,
        "receiveRate": receiveRate.value,
        "exchangeRate": exchangeRate.value,
        "statusCode": uriResponse.statusCode,
        "storeExchangeRate": data[data.keys.last]["val"],
        "localExchangeRate": data[data.keys.first]["val"],
        "localTotalExchangeRate": (data[data.keys.first]["val"] * transactionService.transactionAmount.value),
        "success": true,
        "exchangeSuccess": true,
      };
    } else {
      exchangeSuccess.value = false;

      return {
        "statusCode": 404,
        "message": "Please try again later",
        "success": false,
        "exchangeSuccess": false,
      };
    }
  }

  Future<Map<String, dynamic>> productCurrencyExchangeConverter({required String localCurrency, required String remoteCurrency}) async {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}

    var client = Client();
    // https://www.currencyconverterapi.com/dev;

    //apiKey:24cbc3faa76a763d73c0
    //apiKey:05cad5bc31ca4aa4a8354b760818580e
    //https://free.currconv.com
    var uriResponse = await client.get(
      Uri.parse('https://api.currconv.com/api/v7/convert?q=${localCurrency}_$remoteCurrency,'
          '${remoteCurrency}_$localCurrency&compact=y&apiKey=05cad5bc31ca4aa4a8354b760818580e'),
    );

    if (uriResponse.statusCode == 200) {
      exchangeSuccess.value = true;
      Map<String, dynamic> data = await json.decode(uriResponse.body);
      print("currency data");
      print(data);
      print(data.keys.last);
      print(data[data.keys.last]);
      print(data[data.keys.last]["val"]);
      print(data[data.keys.first]["val"]);

      // // Map<String, dynamic> rec_user =await data["${widget.contactCurrency}_${widget.userCurrency}"];
      // Map<String, dynamic> uerRec = await data["${transactionService.localCurrency}_${transactionService.remoteCurrency}"];
      // // print("uerRec");
      // // print(uerRec);
      // exchangeRate.value = double.parse(uerRec.values.first.toString());
      // receiveRate.value = (double.parse(uerRec.values.first.toString()) * transactionService.transactionAmount.value);

      exchangeCharges();
      return {
        "data": data,
        "receiveRate": receiveRate.value,
        "exchangeRate": exchangeRate.value,
        "statusCode": uriResponse.statusCode,
        "storeExchangeRate": data[data.keys.last]["val"],
        "localExchangeRate": data[data.keys.first]["val"],
        "localTotalExchangeRate": (data[data.keys.first]["val"] * transactionService.transactionAmount.value),
        "success": true,
        "exchangeSuccess": true,
      };
    } else {
      exchangeSuccess.value = false;

      return {
        "statusCode": 404,
        "message": "Please try again later",
        "success": false,
        "exchangeSuccess": false,
      };
    }
  }

  void processContractExchange() {
    transactionService.data = {
      "receiveRate": exchangeController.receiveRate.value,
      "exchangeRate": exchangeController.exchangeRate.value,
      "moweReceiveRate": exchangeController.moweReceiveRate.value.toString(),
      "moweExchangeRate": exchangeController.moweExchangeRate.value,
      "moweTotalProfit": exchangeController.moweTotalProfit.value,
      "moweProfitMinusAffiliate": exchangeController.moweTotalProfit.value - exchangeController.affiliatePayOutAmount.value,
      "moweProfitOnExchangeRate": exchangeController.moweProfitOnExchangeRate.value,
      "amountToBeExchange": exchangeController.amountToBeExchange.value,
      "exchangeFrom": exchangeController.exchangeFrom.value,
      "exchangeTo": exchangeController.exchangeTo.value,
      "dateTime": Timestamp.now(),
    };
    print(transactionService.data);
    firebaseFirestore.collection(dbHelper.contractExchange()).add(transactionService.data!).then((DocumentReference reference) {
      exchangeReference = reference;
      defaultExchangeProcess();
    });
  }

  RxDouble exchangeMarkDownPercent = RxDouble(0.0);
  void exchangeCharges() {
    // print("exchangeCharges");
    double percent = (exchangeMarkDownPercent / 100);
    moweProfitOnExchangeRate.value = exchangeRate.value * percent;
    moweTotalProfit.value = moweProfitOnExchangeRate.value * transactionService.transactionAmount.value;
    moweExchangeRate.value = (exchangeRate.value - moweProfitOnExchangeRate.value);
    moweReceiveRate.value = moweExchangeRate.value * transactionService.transactionAmount.value;
    affiliatePayment();
  }

  RxDouble affiliatePayOutAmount = RxDouble(0.0);
  RxDouble affiliateMarkDownPercent = RxDouble(0.0);

  void affiliatePayment() {
    double percent = (affiliateMarkDownPercent.value / 100);
    affiliatePayOutAmount.value = moweTotalProfit.value * percent;
  }

  void completeTransaction() {
    transactionService.data = {
      "receiveRate": exchangeController.receiveRate.value,
      "exchangeRate": exchangeController.exchangeRate.value,
      "moweReceiveRate": exchangeController.moweReceiveRate.value.toString(),
      "moweExchangeRate": exchangeController.moweExchangeRate.value,
      "moweTotalProfit": exchangeController.moweTotalProfit.value,
      "moweProfitMinusAffiliate": exchangeController.moweTotalProfit.value - exchangeController.affiliatePayOutAmount.value,
      "moweProfitOnExchangeRate": exchangeController.moweProfitOnExchangeRate.value,
      "amountToBeExchange": exchangeController.amountToBeExchange.value,
      "exchangeFrom": exchangeController.exchangeFrom.value,
      "exchangeTo": exchangeController.exchangeTo.value,
      "dateTime": Timestamp.now(),
    };
    firebaseFirestore.collection(dbHelper.currencyExchangeTransfers()).add(transactionService.data!).then((DocumentReference reference) async {
      exchangeReference = reference;
      transactionService.processTransact();
      // defaultExchangeProcess();
    });
  }

  void defaultExchangeProcess() {
    if (affiliateController.memberUserIsAffiliatedTo != null) {
      if (transactionService.remoteCurrency != affiliateController.memberUserIsAffiliatedTo!.get("currencyCode")) {
        transactionService.localCurrency = transactionService.data!["exchangeTo"];
        transactionService.remoteCurrency = affiliateController.memberUserIsAffiliatedTo!.get("currencyCode");
        transactionService.transactionAmount.value = exchangeController.affiliatePayOutAmount.value;

        exchangeController.currencyExchangeConverter().then((Map<String, dynamic> value) {
          exchangeReference!.update({
            "affiliateCurrency": affiliateController.memberUserIsAffiliatedTo!.get("currencyCode"),
            "affiliatePayOutAmount": exchangeController.moweReceiveRate.value,
          });
          affiliateController.memberUserIsAffiliatedTo!.reference.update({
            "earned": affiliateController.memberUserIsAffiliatedTo!.get("earned") + exchangeController.moweReceiveRate.value,
          });
          exchangeController.amountToBeExchange.value = 0.0;
        }).then((value) async {
          convertProfitToUSD();
        });
      } else {
        exchangeReference!.update({
          "affiliateCurrency": affiliateController.memberUserIsAffiliatedTo!.get("currencyCode"),
          "affiliatePayOutAmount": exchangeController.affiliatePayOutAmount.value,
        });
        affiliateController.memberUserIsAffiliatedTo!.reference.update({
          "earned": affiliateController.memberUserIsAffiliatedTo!.get("earned") + exchangeController.affiliatePayOutAmount.value,
        });

        exchangeReference!.get().then((value) {
          DocumentSnapshot snapshot = value;
          exchangeMarkDownPercent.value = 0.0;
          transactionService.localCurrency = transactionService.remoteCurrency;
          transactionService.remoteCurrency = "USD";
          transactionService.transactionAmount.value = snapshot.get("moweProfitMinusAffiliate");

          if (transactionService.localCurrency != "USD") {
            exchangeController.currencyExchangeConverter().then((value) {
              exchangeReference!.update({
                "profitToUSD": transactionService.remoteCurrency,
                "moweProfitMinusAffiliateToUSD": exchangeController.receiveRate.value,
              });
              exchangeController.amountToBeExchange.value = 0.0;
            });
          } else {
            exchangeReference!.update({
              "profitToUSD": transactionService.remoteCurrency,
              "moweProfitMinusAffiliateToUSD": snapshot.get("moweProfitMinusAffiliate"),
            });
          }
        });
      }
    } else {
      convertProfitToUSD();
    }
  }

  void chargeInstantCashOut() {
    instantCashOutTransactionAmount.value = (transactionService.transactionAmount.value - instantCashOutCharge.value).toDouble();
    moweTotalProfit.value = instantCashOutCharge.value;
    affiliatePayment();
  }

  // DocumentReference? instantCashOutChargeRef;
  void completeInstantCashOut() {
    //
    // print("completeInstantCashOut");
    // print((instantCashOutCharge.value - affiliatePayOutAmount.value).toDouble());
    // print(instantCashOutCharge.value);
    // print(affiliatePayOutAmount.value);

    Map<String, dynamic> data = {
      "cashOutAmount": transactionService.transactionAmount.value,
      "instantCashOutCharge": instantCashOutCharge.value.toDouble(),
      "instantCashOutChargeCurrencyCode": chatServices.localMember!.get(memberModel.currencyCode),
      "moweProfitMinusAffiliate": (instantCashOutCharge.value - affiliatePayOutAmount.value).toDouble(),
      "moweTotalProfit": exchangeController.moweTotalProfit.value.toDouble(),
      "dateTime": Timestamp.now(),
    };
    firebaseFirestore.collection(dbHelper.instantCashOutCharges()).add(data).then((DocumentReference reference) {
      exchangeReference = reference;
      checkAndPayAffiliate();
    });
  }

  void checkAndPayAffiliate() {
    print("checkAndPayAffiliate");
    if (affiliateController.memberUserIsAffiliatedTo != null) {
      if (chatServices.localMember!.get(memberModel.currencyCode) != affiliateController.memberUserIsAffiliatedTo!.get("currencyCode")) {
        transactionService.remoteCurrency = affiliateController.memberUserIsAffiliatedTo!.get("currencyCode");
        transactionService.localCurrency = chatServices.localMember!.get(memberModel.currencyCode);
        exchangeReference!.get().then((DocumentSnapshot snapshot) {
          transactionService.transactionAmount.value = snapshot.get("moweProfitMinusAffiliate");

          exchangeController.currencyExchangeConverter().then((valueva) {
            exchangeReference!.update({
              "affiliateCurrency": affiliateController.memberUserIsAffiliatedTo!.get("currencyCode"),
              "affiliatePayOutAmount": exchangeController.moweReceiveRate.value,
            });
            affiliateController.memberUserIsAffiliatedTo!.reference.update({
              "earned": affiliateController.memberUserIsAffiliatedTo!.get("earned") + exchangeController.moweReceiveRate.value,
            });
            exchangeController.amountToBeExchange.value = 0.0;
          }).then((value) async {
            convertProfitToUSD();
          });
        });
      } else {
        exchangeReference!.update({
          "affiliateCurrency": affiliateController.memberUserIsAffiliatedTo!.get("currencyCode"),
          "affiliatePayOutAmount": affiliatePayOutAmount.value,
        });
        affiliateController.memberUserIsAffiliatedTo!.reference.update({
          "earned": affiliateController.memberUserIsAffiliatedTo!.get("earned") + affiliatePayOutAmount.value,
        });
        exchangeController.amountToBeExchange.value = 0.0;

        exchangeReference!.get().then((value) {
          DocumentSnapshot snapshot = value;
          exchangeMarkDownPercent.value = 0.0;
          transactionService.localCurrency = chatServices.localMember!.get(memberModel.currencyCode);
          transactionService.remoteCurrency = "USD";
          transactionService.transactionAmount.value = snapshot.get("moweProfitMinusAffiliate");

          if (transactionService.localCurrency != "USD") {
            exchangeController.currencyExchangeConverter().then((value) {
              exchangeReference!.update({
                "profitToUSD": transactionService.remoteCurrency,
                "moweProfitMinusAffiliateToUSD": exchangeController.receiveRate.value,
              });
              exchangeController.amountToBeExchange.value = 0.0;
            });
          } else {
            exchangeReference!.update({
              "profitToUSD": transactionService.remoteCurrency,
              "moweProfitMinusAffiliateToUSD": snapshot.get("moweProfitMinusAffiliate"),
            });
            exchangeController.amountToBeExchange.value = 0.0;
          }
        });
      }
    }
  }

  Future<void> convertProfitToUSD() async {
    DocumentSnapshot snapshot = await exchangeReference!.get();
    exchangeMarkDownPercent.value = 0.0;
    transactionService.localCurrency = transactionService.data!["exchangeTo"];
    transactionService.remoteCurrency = "USD";
    transactionService.transactionAmount.value = snapshot.get("moweProfitMinusAffiliate");
    exchangeController.currencyExchangeConverter().then((value) {
      exchangeReference!.update({
        "profitToUSD": transactionService.remoteCurrency,
        "moweProfitMinusAffiliateToUSD": exchangeController.receiveRate.value,
      });
      exchangeController.amountToBeExchange.value = 0.0;
      transactionService.setPaymentToEmpty();
    });
  }

  void cashOut() {
    switch (enumServices.currencyTypes) {
      case CurrencyTypes.USD:
        if (transactionService.transactionAmount.value > 0 && transactionService.transactionAmount.value <= 100) {
          instantCashOutCharge.value = ((serviceChargesSnap!.get("cashOutUnder100Usd").toDouble() / 100) * transactionService.transactionAmount.value).toDouble();
          chargeInstantCashOut();
        } else if (transactionService.transactionAmount.value > 100 && transactionService.transactionAmount.value <= 200) {
          instantCashOutCharge.value = ((serviceChargesSnap!.get("cashOutUnder200Usd").toDouble() / 100) * transactionService.transactionAmount.value).toDouble();
          chargeInstantCashOut();
        } else if (transactionService.transactionAmount.value > 200 && transactionService.transactionAmount.value <= 300) {
          instantCashOutCharge.value = ((serviceChargesSnap!.get("cashOutUnder300Usd").toDouble() / 100) * transactionService.transactionAmount.value).toDouble();
          chargeInstantCashOut();
        } else {
          instantCashOutCharge.value = (5.0 / 100) * transactionService.transactionAmount.value;
          chargeInstantCashOut();
        }
        break;
      case CurrencyTypes.GHS:
        if (transactionService.transactionAmount.value > 0 && transactionService.transactionAmount.value <= 100) {
          instantCashOutCharge.value = ((serviceChargesSnap!.get("cashOutUnder100Ghs").toDouble() / 100) * transactionService.transactionAmount.value).toDouble();
          chargeInstantCashOut();
        } else if (transactionService.transactionAmount.value > 100 && transactionService.transactionAmount.value <= 200) {
          instantCashOutCharge.value = (serviceChargesSnap!.get("cashOutUnder200Ghs").toDouble() / 100) * transactionService.transactionAmount.value;
          chargeInstantCashOut();
        } else if (transactionService.transactionAmount.value > 200 && transactionService.transactionAmount.value <= 300) {
          instantCashOutCharge.value = (serviceChargesSnap!.get("cashOutUnder300Ghs").toDouble() / 100) * transactionService.transactionAmount.value;
          chargeInstantCashOut();
        } else {
          instantCashOutCharge.value = (3.0 / 100) * transactionService.transactionAmount.value;
          chargeInstantCashOut();
        }
        break;
      case CurrencyTypes.NGN:
        // TODO: Handle this case.
        break;
      case CurrencyTypes.GBP:
        // TODO: Handle this case.
        break;
    }
  }
}