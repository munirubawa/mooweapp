import 'package:mooweapp/export_files.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            if(navController.callStatus.value == CallActionStatus.CALL_START) {
              navController.pipPage = MarketPlaceHomeScreen();
              navController.smallScreen();
            } else {
              Get.back();
            }
          },
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Order History",
          style: themeData!.textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firebaseFirestore.collection(dbHelper.addToStoreOrders()).where("buyerId", isEqualTo: dbHelper.userId()).snapshots(), // async work
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: Loading());
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {

                        // snapshot.data!.docs.toList().sort();
                        // DateFormat.yMMMMd('en_US').format(DateTime.now())
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot<Object?> orders = snapshot.data!.docs[index];
                            Timestamp dateTime = orders.get("dateTime");
                            return InkWell(
                              onTap: (){
                                enumServices.shoppingCartOrigin = ShoppingCartOrigin.HISTORY;
                                Get.to(()=> OrderSuccessScreen(orderData: orders));
                              },
                              child: Container(
                                color: index.isOdd ? Colors.white : Colors.black12,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Order Date:"),
                                      Text("${DateFormat.yMMMMEEEEd('en_US').format(dateTime.toDate())}, ${DateFormat.jm('en_US').format(dateTime.toDate())}"),
                                      const Text("Order ID"),
                                      Text("${orders.get("orderId")}"),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text("No Orders yet"),
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserOrderHistoryController extends GetxController{
static UserOrderHistoryController instance = Get.find();

}
