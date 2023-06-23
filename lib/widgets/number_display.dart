import 'package:mooweapp/export_files.dart';

class NumberDisplay extends StatelessWidget {
   NumberDisplay({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Center(
        child: Obx((){
          return Text(
            transactionService.displayAmount.value.toString(),
            style: currencyStyle(transactionService.displayAmount.value),
          );
        }),
      ),
    );
  }

  TextStyle currencyStyle(String currency){
    TextStyle style = themeData!.textTheme.headline2!.copyWith(color: Colors.white, fontSize: Get.width * 0.5);
    debugPrint(currency.length.toString());
    switch (currency.length) {
      case 1:
        return style;
      case 2:
        return style.copyWith(fontSize: Get.width * 0.4);
      case 3:
        return style.copyWith(fontSize: Get.width * 0.365);
      case 4:
        return style.copyWith(fontSize: Get.width * 0.34);
      case 5:
        return style.copyWith( fontSize: Get.width * 0.3);
      case 6:
        return style.copyWith(fontSize: Get.width * 0.24);
      case 7:
        return style.copyWith(fontSize: Get.width * 0.08);
      case 8:
        return style.copyWith(fontSize: Get.width * 0.06);
      case 9:
        return style.copyWith(fontSize: Get.width * 0.04);
      default:
        return style.copyWith(fontSize: Get.width * 0.15);
    }
  }
}
