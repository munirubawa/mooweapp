import 'package:mooweapp/export_files.dart';

class ProductView extends StatelessWidget {
  ProductPayload product;
  ProductView({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            if (navController.callStatus.value == CallActionStatus.CALL_START) {
              navController.pipPage = MarketPlaceHomeScreen();
              navController.smallScreen();
            } else {
              Get.back();
            }
          },
        ),
        actions: [
          Obx(() => Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {
                      showBarModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          color: Colors.white,
                          child: ShoppingCartWidget(),
                        ),
                      );
                    },
                  ),
                  CircleAvatar(
                    maxRadius: 10,
                    backgroundColor: Colors.lightGreen,
                    child: Text(
                      "${cartController.cart.value.length}",
                      style: themeData!.textTheme.bodySmall!.copyWith(color: Colors.white),
                    ),
                  )
                ],
              )),
        ],
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.height * 0.50,
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

              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 20),
                child: Table(
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "${paymentsController.numCurrency(product.buyerPrice)} ${product.buyerCurrencyCode}",
                          style: themeData!.textTheme.headline6,
                        ),
                        // child: CustomText(
                        //   text: "\$${product.price}",
                        //   size: 22,
                        //   weight: FontWeight.bold,
                        // ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            if (kDebugMode) {
                              print("cartController.addProductToCart(product)");
                              print(product.toMap());
                            }
                            Get.defaultDialog(
                                title: "Add To Cart",
                                content: const Text(""),
                                confirm: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: InkWell(
                                        child: const Text("Cancel"),
                                        onTap: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: InkWell(
                                        child: const Text("Add To Cart"),
                                        onTap: () {
                                          cartController.addProductToCart(product);
                                          Get.back();
                                        },
                                      ),
                                    ),
                                  ],
                                ));
                          }),
                    ])
                  ],
                ),
              )
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //
              //     const SizedBox(
              //       width: 30,
              //     ),
              //
              //   ],
              // ),
              // Expanded(flex: 5,child: Container())
            ],
          ),
        ),
      ),
    );
  }
}
