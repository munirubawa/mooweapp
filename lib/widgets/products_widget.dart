import 'package:mooweapp/export_files.dart';

class ProductsWidget extends StatelessWidget {
  const ProductsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(()=>GridView.count(
        crossAxisCount: 2,
        childAspectRatio: .63,
        padding: const EdgeInsets.all(10),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 10,
        children: productsController.products.map((ProductPayload product) {
          return InkWell(
            onTap: (){
              print("product.toMap()");
              print(product.toMap());

              if(navController.callStatus.value == CallActionStatus.CALL_START) {
                navController.pipPage = ProductView(product: product);
                navController.smallScreen();
              } else {
                Get.to(()=> ProductView(product: product));
              }
            },
            // child: SingleProductWidget(product: productsController.updateProducts(product),),
            child:  FutureBuilder<ProductPayload>(
              future:  productsController.updateProducts(product), // async work
              builder: (BuildContext context, AsyncSnapshot<ProductPayload> snapshot) {
                // if(!snapshot.hasData) {
                //   return Container();
                // }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: return const Text('Loading....');
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return SingleProductWidget(product: snapshot.data!,);
                    }

                }
            },
          ));
        }).toList()));
  }
}
