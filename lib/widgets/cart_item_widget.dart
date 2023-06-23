import 'package:mooweapp/export_files.dart';
class CartItemWidget extends StatelessWidget {
  final ProductPayload cartItem;

  const CartItemWidget({Key? key, required this.cartItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("CartItemWidget");
    print(cartItem.toMap());
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: [
        Padding(
          padding:
          const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 70,
            width: 70,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: storage.networkImage(
                    cartItem.images![0],
                    shape: BoxShape.rectangle
                )),
          ),
        ),
        Expanded(
            child: Wrap(
              direction: Axis.vertical,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 14),
                    child: CustomText(
                      text: cartItem.name.toString(),
                    )),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: const Icon(
                            Icons.chevron_left),
                        onPressed: () {
                          // cartController.decreaseQuantity(cartItem);
                        }),
                    Padding(
                      padding:
                      const EdgeInsets.all(
                          8.0),
                      child: CustomText(
                        text: cartItem.quantity.toString(),
                      ),
                    ),
                    IconButton(
                        icon: const Icon(Icons
                            .chevron_right),
                        onPressed: () {
                          // cartController.increaseQuantity(cartItem);
                        }),
                  ],
                )
              ],
            )),
        Padding(
          padding:
          const EdgeInsets.all(14),
          child: CustomText(
            text: "${paymentsController.numCurrency(cartItem.buyerPrice.toDouble())} ${chatServices.localMember!.get(memberModel.currencyCode)}",
            size: 22,
            weight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
