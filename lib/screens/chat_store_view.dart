import 'package:mooweapp/export_files.dart';
class ChatStoreView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  ChatStoreView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryColor,
        key: _key,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Row(
            children: [
              Obx(()=>Text(storeController.storeBusiness.value.businessName.toString(), style: themeData!.textTheme.bodyLarge!
                  .copyWith(color: kPrimaryColor),)),
              Expanded(child: Container()),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: kPrimaryColor,),
            onPressed: () {

              if(navController.callStatus.value == CallActionStatus.CALL_START) {
                navController.pipPage = ShowUserProfileOptions();
                navController.smallScreen();
              } else {
                Get.back();
                // Get.to(() => ChatStoreView());
              }
            },
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.shopping_cart, color: kPrimaryColor,),
                onPressed: () {

                  // showModalBottomSheet(
                  //   context: context,
                  //   builder: (context) => Container(
                  //     color: Colors.white,
                  //     child: ShoppingCartWidget(),
                  //   ),
                  // );
                }),
            IconButton(
                icon: const Icon(Icons.menu, color: kPrimaryColor,),
                onPressed: () {
                  _key.currentState!.openEndDrawer();
                }),
          ],
          elevation: 0,
          centerTitle: true,
        ),
        // backgroundColor: Colors.white,
        endDrawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.book),
                title: const CustomText(
                  text: "Payments History",
                ),
                onTap: () async {
                  // paymentsController.getPaymentHistory();
                },
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.exit_to_app),
                title: const Text("Log out"),
              )
            ],
          ),
        ),
        body: Container(
          color: Colors.white30,
          child: Container(color: Colors.white,
              child: const ChatStoreProductsWidget()),
        ));
  }
}


class ChatStoreProductsWidget extends StatelessWidget {
  const ChatStoreProductsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(()=>GridView.count(
        crossAxisCount: 2,
        childAspectRatio: .63,
        padding: const EdgeInsets.all(10),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 10,
        children: storeController.storeProducts.map((ProductPayload product) {
          return InkWell(
            onTap: (){
              if(navController.callStatus.value == CallActionStatus.CALL_START) {
                navController.pipPage = ProductView(product: product);
                navController.smallScreen();
              } else {
                Get.to(()=> ProductView(product: product));
              }
            },
            child: SingleProductWidget(product: product,),
          );
          // return SingleProductWidget(product: product,);
        }).toList()));
  }
}