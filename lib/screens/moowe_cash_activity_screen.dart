import 'package:mooweapp/export_files.dart';
class MooweCashActivityScreen extends StatelessWidget {
  const MooweCashActivityScreen({
    key = Key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx((){
              transactionService.userTransactions.value.sort(( b, a) => a.time!.compareTo(b.time!));

              return ListView.builder(
                  itemCount: transactionService.userTransactions.value.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {

                    TransactionPayload payload = transactionService.userTransactions.value[index];
                    switch (payload.payloadType!) {
                      case TransactionPayloadType.REQUEST_PAYMENT:
                      // TODO: Handle this case.
                        return Container(
                          color: index.isOdd ? Colors.white : Colors.black12,
                            child: RequestPaymentCard(payload: payload));
                      case TransactionPayloadType.TRANSACTION:
                      // TODO: Handle this case.
                      // MooweTransactions.fromJson(payload.data).firstName != "Cash In"?
                        return Container(
                          color: index.isOdd ? Colors.white : Colors.black12,
                          child: TransactionSummary(
                            payload: payload,
                          ),
                        );
                      case TransactionPayloadType.EXCHANGE_TRANSACTION:
                      // TODO: Handle this case.
                        return Container();
                      case TransactionPayloadType.DECLINE_PAYMENT_REQUEST:
                      // TODO: Handle this case.
                        return Container(
                            color: index.isOdd ? Colors.white : Colors.black12,
                            child: RequestPaymentCard(payload: payload));
                      case TransactionPayloadType.REQUEST_PAID:
                      // TODO: Handle this case.
                        return Container(
                            color: index.isOdd ? Colors.white : Colors.black12,
                            child: RequestPaymentCard(payload: payload));
                    }
                  });
            } )
          ],
        ),
      ),
    );
  }
}

class RequestPaymentCard extends StatelessWidget {
  final TransactionPayload? payload;

  const RequestPaymentCard({Key? key, required this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        // decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              payloadEnumString(payload!),
              TransactionSummary(
                payload: payload,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text("Note: "),
                    Text(payload!.note.toString()),
                  ],
                ),
              ),
              paymentRequestDeclineButtons(payload!),
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentRequestDeclineButtons(TransactionPayload payload) {
    switch (payload.payloadType!) {
      case TransactionPayloadType.REQUEST_PAYMENT:
        // TODO: Handle this case.
        return ButtonBar(
          children: [
            TextButton(
              onPressed: () {
                enumServices.transactionType = TransactionType.DECLINE_PAYMENT_REQUEST;
                enumServices.transactionActionType = TransactionActionType.DECLINE_PAYMENT_REQUEST;
                // enumServices.userActionType = UserActionType.SEND_CASH_DIRECT_FROM_MOOWE_PAY;
                payload.reference!.update({
                  "payloadType": EnumToString.convertToString(TransactionPayloadType.DECLINE_PAYMENT_REQUEST),
                  "transactionType": EnumToString.convertToString(TransactionType.DECLINE_PAYMENT_REQUEST),
                });
              },
              child: const Text("Decline"),
            ),
            TextButton(
              onPressed: () async {
                enumServices.transactionType = TransactionType.EXPENSE;
                enumServices.transactionActionType = TransactionActionType.PROCESS_REQUEST_PAYMENT;
                transactionService.member =
                    await FirebaseFirestore.instance.doc(payload.contactPath.toString()).get().then((value) => value);
             MooweTransactions tr =   MooweTransactions.fromJson(payload.data);
             transactionService.transactionAmount.value = tr.value!;
              tr.credit = tr.value;
                payload.reference!.update({
                  "payloadType": EnumToString.convertToString(TransactionPayloadType.REQUEST_PAID),
                  "transactionType": EnumToString.convertToString(TransactionType.EXPENSE),
                  "data": tr.toMap(),
                });
                transactionService.runTransaction();
              },
              child: const Text("Pay"),
            ),
          ],
        );
      case TransactionPayloadType.TRANSACTION:
        // TODO: Handle this case.
        return Container();
      case TransactionPayloadType.EXCHANGE_TRANSACTION:
        // TODO: Handle this case.
        return Container();
      case TransactionPayloadType.DECLINE_PAYMENT_REQUEST:
        // TODO: Handle this case.
        return Container();
      case TransactionPayloadType.REQUEST_PAID:
        // TODO: Handle this case.
        return Container();
    }
  }

  Widget payloadEnumString(TransactionPayload payload) {
    switch (payload.payloadType!) {
      case TransactionPayloadType.REQUEST_PAYMENT:
        // TODO: Handle this case.
        return Container(
          decoration: const BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(5))),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Request",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      case TransactionPayloadType.TRANSACTION:
        // TODO: Handle this case.
        return Container(
          decoration: const BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(5))),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );

      case TransactionPayloadType.EXCHANGE_TRANSACTION:
        // TODO: Handle this case.
        return Container(
          decoration: const BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(5))),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Request",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      case TransactionPayloadType.DECLINE_PAYMENT_REQUEST:
        // TODO: Handle this case.
        return Container(
          decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(5))),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Request Declined",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      case TransactionPayloadType.REQUEST_PAID:
        // TODO: Handle this case.
        return Container(
          decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(5))),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Request Paid",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
    }
  }
}
