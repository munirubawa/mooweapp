import 'package:mooweapp/export_files.dart';

class FundingComplete extends StatelessWidget {
 DocumentSnapshot? message;
 FundingComplete({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var funding = FundingCompleteMessage.fromMap(message!.get(messagePayloadModel.messages)[0]);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
                Radius.circular(10)
            )
        ),
        width: Get.width * 0.8,
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: Get.width * 0.7,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          child: Text( funding.message!.text!, style: const TextStyle(fontWeight: FontWeight.bold),)),
                    ),
                    Container(
                      child: Icon(Icons.check, color: Colors.green, size: Get.width * 0.2,),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
