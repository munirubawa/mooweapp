import 'package:mooweapp/export_files.dart';
class BackCard extends StatelessWidget {
  final CreditCard? card;
  colorFun(String color) {
    String valueString = color.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    Color otherColor = Color(value);
    return otherColor;
  }

  const BackCard({Key? key, this.card}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5 / 3,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: colorFun(card!.colors![1])),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Get.width * 0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: Get.width * 0.2,
                color: colorFun(card!.colors![0]),
              ),
              Container(
                margin: EdgeInsets.only(top: Get.width * 0.1, right: Get.width * 0.1),
                padding: EdgeInsets.only(right: Get.width * 0.1),
                height: Get.width * 0.2,
                width: Get.width * 0.2,
                color: Colors.white,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(card!.securityCode!),
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(right: Get.width * 0.1),
                child: Text("Service Hotline / 028-6577", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
