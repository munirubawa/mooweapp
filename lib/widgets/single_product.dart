import 'package:mooweapp/export_files.dart';

class SingleProductWidget extends StatelessWidget {
  final ProductPayload product;

  const SingleProductWidget({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("SingleProductWidget");
    print(product.toMap());
    // if (product.buyerCurrencySign == "") {
    //   productsController.updateProducts();
    // }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // boxShadow: [
        //   BoxShadow(
        //       color: Colors.grey.withOpacity(.2),
        //       offset: const Offset(3, 2),
        //       blurRadius: 7)
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: storage.networkImage(product.images![0].toString(), shape: BoxShape.rectangle, fit: BoxFit.contain)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name.toString(),
                  style: themeData!.textTheme.bodyLarge,
                ),
                Text(
                  product.brand.toString(),
                  style: themeData!.textTheme.bodyLarge!.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "${paymentsController.numCurrency(product.buyerPrice.toDouble())} ${product.buyerCurrencyCode}",
                  style: themeData!.textTheme.headline6,
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              // IconButton(
              //     icon: const Icon(Icons.add_shopping_cart),
              //     onPressed: () {
              //       cartController.addProductToCart(product);
              //     })
            ],
          ),
        ],
      ),
    );
  }
}
