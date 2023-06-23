import 'package:mooweapp/export_files.dart';
class MarketPlaceHomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  MarketPlaceHomeScreen({Key? key}) : super(key: key);
  List<LogicalKeyboardKey> keys = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      key: _key,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Obx(
          () => productsController.marketAppBarActions.value == MarketAppBarActions.SEARCH
              ? RawKeyboardListener(
            autofocus: true,
            focusNode: FocusNode(),
            onKey: (RawKeyEvent event) {

              final key = event.logicalKey;
              if (event is RawKeyDownEvent) {
                // keys.add(key);
                // print("evenetkeyspressed");
                // print(key);
                // print(keys);
                // print(keys.contains(LogicalKeyboardKey.enter));
                if(keys.contains(LogicalKeyboardKey.control) && keys.contains(LogicalKeyboardKey.enter)) {
                }
              }
            },
                child: Row(
                    children:  [
                       Expanded(child: TextField(
                        onChanged: (String value){
                        productsController.searchWord.value = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'search product name...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),),
                      IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {
                            productsController.changeSearchBar(MarketAppBarActions.CANCEL_SEARCH);
                          }),
                    ],
                  ),
              )
              : Container(),
        ),
        actions: [
          Obx(
            () => productsController.marketAppBarActions.value == MarketAppBarActions.CANCEL_SEARCH
                ? Row(
                    children: [
                      IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {
                            productsController.changeSearchBar(MarketAppBarActions.SEARCH);
                          }),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.shopping_cart,
                              color: kPrimaryColor,
                            ),
                            onPressed: () {
                              showBarModalBottomSheet(
                                context: Get.context!,
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
                      ),
                      IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: kPrimaryColor,
                          ),
                          onPressed: () {
                            _key.currentState!.openEndDrawer();
                          }),
                    ],
                  )
                : Container(),
          ),
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
                text: "Order History",
              ),
              onTap: () async {
                if(navController.callStatus.value == CallActionStatus.CALL_START) {
                  navController.pipPage = const OrderHistory();
                  navController.smallScreen();
                } else {
                  Get.back();
                  Get.to(() => const OrderHistory());
                }


              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white30,
        child: Container(color: Colors.white, child: const ProductsWidget()),
      ),
      bottomNavigationBar: HomeNavigationBar(
        tabIndex: 2,
        backgroudColor: Colors.white,
      ),
    );
  }
}
