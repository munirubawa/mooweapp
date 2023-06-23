import 'package:mooweapp/export_files.dart';

class UserSafeContracts extends StatelessWidget {
  const UserSafeContracts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => GridView.count(
        crossAxisCount: 2,
        childAspectRatio: .63,
        padding: const EdgeInsets.all(10),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 10,
        children:
            contractController.userContracts.map((DocumentSnapshot contract) {
          return InkWell(
            onTap: () {
              contractController.contractSnap = contract;
              contractController.contractData.value =
                  contract.data() as Map<String, dynamic>;
              Get.to(() => ViewContract());
            },
            child: SingleContractWidget(
              contract: contract,
            ),
          );
        }).toList()));
  }
}

class SingleContractWidget extends StatelessWidget {
  DocumentSnapshot contract;
  SingleContractWidget({Key? key, required this.contract}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.content_paste_go_outlined,
                size: imageRadius,
              ),
            ),
            Text('${contract.get(conModel.creator)[conModel.firstName]}')
          ],
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          title: Text('${contract.get(conModel.purpose)}',
            maxLines: 6,
            overflow: TextOverflow.ellipsis,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status:', style: themeData!.textTheme.labelLarge),
              Text('${contract.get(conModel.status)}',
                  style: themeData!.textTheme.labelLarge),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                "${paymentsController.numCurrency(contract.get(conModel.contractAmount))} ${contract.get(conModel.creator)[conModel.currencyCode]}",
                style: themeData!.textTheme.headline5!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              // Text('${contract.get(conModel.creator)[conModel.currencyCode]}',
              //     style: themeData!.textTheme.headline5!
              //         .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    );
  }
}
