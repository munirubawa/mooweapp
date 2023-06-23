import 'package:mooweapp/export_files.dart';

class KeyPadDisplay extends StatelessWidget {
  KeyPadDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => transactionService.addNumber(1),
                  child: Container(

                    alignment: Alignment.center,
                    child: Center(
                        child: Text(
                          "1",
                          style: textStyle,
                        )),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => transactionService.addNumber(2),
                  child: Container(
                    alignment: Alignment.center,
                    child: Center(
                        child: Text(
                          '2',
                          style: textStyle,
                        )),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => transactionService.addNumber(3),
                  child: Container(
                    alignment: Alignment.center,
                    child: Center(
                      child: Text(
                        '3',
                        style: textStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => transactionService.addNumber(4),
                  child: Container(
                    alignment: Alignment.center,
                    color: numberColor,
                    child: Center(
                        child: Text(
                          '4',
                          style: textStyle,
                        )),
                  ),
                ),
              ),
              Expanded(child: GestureDetector(
                onTap: () => transactionService.addNumber(5),
                child: Container(
                  alignment: Alignment.center,
                  color: numberColor,
                  child: Center(
                      child: Text(
                        '5',
                        style: textStyle,
                      )),
                ),
              )),
              Expanded(child: GestureDetector(
                onTap: () => transactionService.addNumber(6),
                child: Container(
                  alignment: Alignment.center,
                  color: numberColor,
                  child: Center(
                      child: Text(
                        '6',
                        style: textStyle,
                      )),
                ),
              )),
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: GestureDetector(
                  onTap: () => transactionService.addNumber(7),
                  child: Container(
                    alignment: Alignment.center,
                    color: numberColor,
                    child: Center(
                        child: Text(
                          '7',
                          style: textStyle,
                        )),
                  ),
                ),),
                Expanded(child: GestureDetector(
                  onTap: () => transactionService.addNumber(8),
                  child: Container(
                    alignment: Alignment.center,
                    color: numberColor,
                    child: Center(
                        child: Text(
                          '8',
                          style: textStyle,
                        )),
                  ),
                )),
                Expanded(child: GestureDetector(
                  onTap: () => transactionService.addNumber(9),
                  child: Container(
                    alignment: Alignment.center,
                    color: numberColor,
                    child: Center(
                        child: Text(
                          '9',
                          style: textStyle,
                        )),
                  ),
                )),
              ],
            ),
          ),
        ),
        Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => transactionService.addPeriod(),
                    child: Container(
                      alignment: Alignment.center,
                      child: Center(
                          child: Text(
                            '.',
                            style: textStyle,
                          )),
                    ),
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                      onTap: () => transactionService.addNumber(0),
                      child: Container(
                        alignment: Alignment.center,
                        color: numberColor,
                        child: Center(
                            child: Text(
                              '0',
                              style: textStyle,
                            )),
                      ),
                    )),
                Expanded(
                    child: GestureDetector(
                      onTap: () => transactionService.removeNumber(),
                      child: Container(
                        alignment: Alignment.center,
                        // padding: EdgeInsets.all(SizeConfig.heightMultiplier),
                        child: Center(
                            child: Text(
                              '<',
                              style: textStyle,
                            )),
                      ),
                    )),
              ],
            )),
      ],
    ));
  }

  Color? numberColor = kPrimaryColor.withAlpha(600);
  TextStyle textStyle = TextStyle(color: Colors.white, fontSize: Get.width * 0.09);
}
