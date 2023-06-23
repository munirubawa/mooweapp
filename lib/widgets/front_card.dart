import 'package:mooweapp/export_files.dart';

class FrontCard extends StatelessWidget {
  final CreditCard? card;
  final bool? showCardNumber;
  final bool? animateCardNumber;

  colorFun(String color) {
    String valueString = color.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    Color otherColor = Color(value);
    return otherColor;
  }

  const FrontCard(
      {Key? key,
      @required this.card,
      this.showCardNumber = false,
      this.animateCardNumber = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5 / 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
              colors: [
                colorFun(card!.colors![0]),
                colorFun(card!.colors![1]),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: const [0, 0.8],
              tileMode: TileMode.clamp),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.02,
              // vertical: Get.width * 0.02,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Wallet Card",
                      style: themeData!.textTheme.bodyLarge!.copyWith(color: Colors.white),
                    ),
                    Transform.rotate(
                      angle: pi / 2,
                      child: Icon(
                        Icons.wifi,
                        size: Get.width * 0.1,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    "${card!.currencyCode}",
                    style: themeData!.textTheme.bodySmall!.copyWith(color: Colors.white)
                  ),
                ],
              ),
              const Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  // color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,

                        child: Transform.translate(
                          offset: const Offset(0, 0),
                          child: Image.asset(
                            "assets/card/chip.png",
                            height: 120,
                            width: 80,
                          ),
                        ),
                      ),
                      if (showCardNumber!)
                        Expanded(
                            flex: 14,
                            child: Text(
                              animateCardNumber!
                                  ? card!.number!
                                  .toString()
                                  : card!.number.toString(),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                              style: themeData!.textTheme.headline6!.copyWith(color: Colors.white,
                              )
                                  ,
                            ))
                    ],
                  ),
                ),
              ),
              // const Spacer(
              //   flex: 1,
              // ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CARD HOLDER",
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: Colors.white70),
                          ),
                          Text(
                            card!.nameOnCard.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white),
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                      // const Spacer(),
                      // Image.asset(
                      //   card!.brand == CardBrand.visa ? "assets/card/visa.png" : "assets/card/mastercard.png",
                      //   // card?.brand == CardBrand.visa ? "" : "",
                      //   height: Get.width * 0.06,
                      //   color: card!.brand == CardBrand.visa ? Colors.white70 : null,
                      // )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
