import 'package:mooweapp/export_files.dart';

class Funding extends StatelessWidget {
 DocumentSnapshot? message;
  Funding({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var funding = FundingMessage.fromMap(message!.get(messagePayloadModel.messages)[0]);
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
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          child: Text( funding.message!.text!, style: const TextStyle(fontWeight: FontWeight.bold),)),
                    ),),
                    // Container(
                    //   child: Icon(Icons.check, color: green, size: SizeConfig.heightMultiplier *5,),
                    // )
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
