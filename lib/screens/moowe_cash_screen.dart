import 'package:mooweapp/export_files.dart';
class MooweCashScreen extends StatefulWidget {
  @override
  _MooweCashScreenState createState() => _MooweCashScreenState();
}

class _MooweCashScreenState extends State<MooweCashScreen> {
  double? incomeBalance;
  final bool _showB1 = true;
  Map<String, dynamic> firstCalculation = {};
  bool isCurrencyUSD = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      backgroundColor: kPrimaryColor,
      body: Column(
        children: [
          Expanded(
              flex: 9,
              child: Column(
                children: [
                  NumberDisplay(),
                ],
              )),
          Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10),
                child: Column(
                  children: [
                    KeyPadDisplay(),
                  ],
                ),
              )),
          Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0), side: const BorderSide(color: Colors.teal)))),
                      child: const Icon(Icons.unfold_more),
                      onPressed: () {
                        showBarModalBottomSheet(
                          context: context,
                          builder: (context) => const MoowePayActionButton(),
                        );
                      },
                    ),
                  )),
                ],
              )),
        ],
      ),
      // body: Cashapp(
      //   flexPad: flexPadSize(),
      //   actionWidget: Padding(
      //     padding: const EdgeInsets.only(bottom: 15.0),
      //     child: ,
      //   ),
      // ),
    );
  }

  cashPageOptionOfButtonsBottomSheepModal(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const MoowePayActionButton();
      },
    ).then((value) {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
// int flexPadSize() {
//   if(Platform.isAndroid) {
//
//   } else if(Platform.isIOS) {
//     if(SizeConfig. < 813){
//       return 9;
//     } else {
//       return 5;
//     }
//   }
// return 9;
// }
