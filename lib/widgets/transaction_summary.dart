import 'package:mooweapp/export_files.dart';

class TransactionSummary extends StatelessWidget {
  final TransactionPayload? payload;
  const TransactionSummary({
    Key? key,
    @required this.payload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = payload!.data;
     MooweTransactions? transaction = MooweTransactions.fromJson(data);

    return ListTile(
      title: Text(
        "${transaction.firstName.toString().capitalize!} "
            "${transaction.lastName.toString().isNotEmpty ? transaction.lastName.toString().capitalize! : ""}",
        overflow: TextOverflow.ellipsis,
        style: themeData!.textTheme.headline6!.copyWith(fontSize: Get.width * 0.045),
      ),
      isThreeLine: true,
      subtitle:                Text(
        DateFormat.yMEd().format(DateTime.parse(transaction.timeStamp.toString())),
      ),
      leading: CircleAvatar(
          radius: imageRadius,
          child: storage.checkImage(transaction.imageUrl.toString())
              ? CircleAvatar(
            radius: imageRadius,
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.orange,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: storage.getImage(
                        transaction.imageUrl.toString(),
                      ),
                      fit: BoxFit.cover)),
            ),
          )
              : CircleAvatar(
            radius: imageRadius,
            child: Icon(
              Icons.person,
              size: Get.width * 0.1,
            ),
          )),
      trailing: Wrap(
        children: [
          typeOfTransaction(payload!),
          Text("${paymentsController.numCurrency(transaction.value!)} ${transaction.currencyCode}",
            textAlign: TextAlign.center,
            style: themeData!.textTheme.headline6,)
        ],
      )
      ,
    );
  }

  Widget typeOfTransaction(TransactionPayload payload){
    switch (payload.transactionType!) {
      case TransactionType.CONTRIBUTION:
      case TransactionType.FUNDING:
      case TransactionType.REQUEST_PAYMENT:
      case TransactionType.DECLINE_PAYMENT_REQUEST:
      case TransactionType.REQUEST_PAID:
      case TransactionType.BILL_PAY:
      case TransactionType.CASH_OUT:
        return Container();
      case TransactionType.EXPENSE:
        return const Text("-",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.red, fontSize: 20
          ),);
      case TransactionType.INCOME:
        return const Text("+", style: TextStyle(
            color: Colors.green,
            fontSize: 20
        ),);

    }
    // if(transaction!.credit! > 0.0){
    //   return const Text("-",
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //       color: Colors.red, fontSize: 20
    //   ),);
    // }
    // if(transaction!.debit! > 0.0){
    //   return const Text("+", style: TextStyle(
    //     color: Colors.green,
    //       fontSize: 20
    //   ),);
    // }
    // return const Text("");
  }
}
