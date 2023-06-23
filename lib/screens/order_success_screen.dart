import 'package:mooweapp/export_files.dart';

class OrderSuccessScreen extends StatelessWidget {
  DocumentSnapshot orderData;
  OrderSuccessScreen({Key? key, required this.orderData}) : super(key: key);

  Widget title() {
    switch (enumServices.shoppingCartOrigin) {
      case ShoppingCartOrigin.SHOPPING:
        // TODO: Handle this case.
        return Text("Order Completed", style: themeData!.textTheme.headline6);
      case ShoppingCartOrigin.HISTORY:
        // TODO: Handle this case.
        return Text("Your Order", style: themeData!.textTheme.headline6);
    }
  }

  Widget success() {
    switch (enumServices.shoppingCartOrigin) {
      case ShoppingCartOrigin.SHOPPING:
        // TODO: Handle this case.
        return Container(
          height: Get.height * 0.1,
          color: Colors.green,
          child: Center(
              child: Text(
            "Order was successful",
            style: themeData!.textTheme.headline6!.copyWith(color: Colors.white),
          )),
        );
      case ShoppingCartOrigin.HISTORY:
        // TODO: Handle this case.
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    StoreOrder order = StoreOrder();
    Map<String, dynamic> userOrder = orderData[order.order];
    // orderData.map((key, value) => value);
    List list = userOrder.entries.map((e) => e.value).toList();
    print("orderData[order.order].length");
    print(orderData[order.order].length);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: title(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          success(),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      FutureBuilder<DocumentSnapshot>(
                        future: firebaseFirestore.doc("marketPlace/${list[index]["itemId"]}").get(), // async work
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Text('Loading....');
                            default:
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              ProductPayload payload = ProductPayload.fromSnap(snapshot.data!).copyWith(quantity: 1);
                              payload.buyerPrice = list[index][checkOutModel.buyerPrice];
                              return CartItemWidget(
                                cartItem: payload,
                              );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
Padding(
  padding: const EdgeInsets.all(20.0),
  child:   Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 18.0, left: 15),
        child: Text(
          "Ship to Address",
          style: themeData!.textTheme.headline6,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 18.0),
        child: Text(orderData[order.shipToAddress]),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 0.0, left: 15),
        child: Table(
          children: [
            TableRow(children: <Widget>[
              Text(
                "Shipping Fee: ",
                style: themeData!.textTheme.headline6,
              ),
              Text(
                "${chatServices.localMember!.get(memberModel.currencySign)!}${orderData["shippingFee"]}",
                style: themeData!.textTheme.headline6,
              )
            ]),
            TableRow(children: <Widget>[
              Text(
                "Total:",
                style: themeData!.textTheme.headline6,
              ),
              Text(
                "${chatServices.localMember!.get(memberModel.currencySign)!}${paymentsController.numCurrency(double.parse(orderData["totalAmount"]))}",
                style: themeData!.textTheme.headline6,
              )
            ]),
            TableRow(children: <Widget>[
              Text(
                "Subtotal:",
                style: themeData!.textTheme.headline6,
              ),
              Text(
                "${chatServices.localMember!.get(memberModel.currencySign)!}${paymentsController.numCurrency(double.parse(orderData["subTotalAmount"]))}",
                style: themeData!.textTheme.headline6,
              )
            ]),
          ],
        ),
      ),
    ],
  ),
)

          // Text(orderData[order.order].toString()),

        ],
      ),
    );
  }
}
