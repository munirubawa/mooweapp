import 'package:mooweapp/export_files.dart';
class StoreCreateProduct extends StatefulWidget {
   const StoreCreateProduct({Key? key}) : super(key: key);

  @override
  State<StoreCreateProduct> createState() => _StoreCreateProductState();
}

class _StoreCreateProductState extends State<StoreCreateProduct> {

  Color active = kPrimaryColor;

  MaterialColor notActive = Colors.grey;

  TextEditingController categoryController = TextEditingController();

  TextEditingController brandController = TextEditingController();

  final GlobalKey<FormState> _categoryFormKey = GlobalKey();

  final GlobalKey<FormState> _brandFormKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    TextStyle style = themeData!.textTheme.headline6!.copyWith(color: kPrimaryColor);
    return Scaffold(
        backgroundColor: kPrimaryColor,
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
            Container(
              color: kPrimaryColor,
              height: 100,
            ),
              Expanded(child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.add),
                    title:  Text("Add Product", style: style,),
                    onTap: () {
                      Get.to(()=>  StoreAddProduct());
                    },
                  ),
                  const Divider(),
                  Obx(() => Column(
                    children: storeController.storeProducts.value
                        .map((cartItem) => StoreProductWidget(
                      product: cartItem,
                    ))
                        .toList(),
                  )),
                  // ListTile(
                  //   leading: const Icon(Icons.change_history),
                  //   title:  Text("Products List", style: style,),
                  //   onTap: () {},
                  // ),
                  // const Divider(),
                  // ListTile(
                  //   leading: const Icon(Icons.add_circle),
                  //   title: Text("Add Category", style: style,),
                  //   onTap: () {
                  //     _categoryAlert();
                  //   },
                  // ),
                  // const Divider(),
                  // ListTile(
                  //   leading: const Icon(Icons.category),
                  //   title: Text("Category List", style: style,),
                  //   onTap: () {},
                  // ),
                  // const Divider(),
                  // ListTile(
                  //   leading: const Icon(Icons.add_circle_outline),
                  //   title: Text("Add Brand", style: style,),
                  //   onTap: () {
                  //     _brandAlert();
                  //   },
                  // ),
                  // const Divider(),
                  // ListTile(
                  //   leading: const Icon(Icons.library_books),
                  //   title: Text("Brand List", style: style,),
                  //   onTap: () {},
                  // ),
                  // const Divider(),
                ],
              )),
            ],
          ),
        ));
  }





}


class StoreProductWidget extends StatelessWidget {
  final ProductPayload product;

  const StoreProductWidget({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: [
        Padding(
          padding:
          const EdgeInsets.all(8.0),
          child: storage.checkImage(product.images![0])? Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: storage.getImage(
                    product.images![0],
                  ),
                  fit: BoxFit.fill),
            ),
          ) :SizedBox(
            height: 55,
            width: 55,
            child: storage.networkImage(product.images![0], shape: BoxShape.rectangle),
          ),
        ),
        Expanded(
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                Container(
                    padding: const EdgeInsets.only(left: 14),
                    child: CustomText(
                      text: product.name.toString(),
                    )),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Table(
                  children: [
                    TableRow(
                        children: [
                          const Text("Quantity"),
                          CustomText(
                            text: product.quantity.toString(),
                          ),
                        ]
                    )
                  ],
                ),
              ),
            ],
          ),
              ],
            )),
        Padding(
          padding:
          const EdgeInsets.all(14),
          child: CustomText(
            text: "${product.price} ${product.currencyCode}",
            size: 22,
            weight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}