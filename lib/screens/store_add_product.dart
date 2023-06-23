import 'package:mooweapp/export_files.dart';

enum AddCategoryBrandOptions {
  SETTING,
}

ExtraDataType extraDataType = ExtraDataType.GENERAL;

class StoreAddProduct extends StatelessWidget {
  StoreAddProduct({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AddProductController addProductController = Get.find();
    // addProductController.getCategories();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        title: Text(
          "New Product",
          style: themeData!.textTheme.headline5!.copyWith(color: Colors.white),
        ),
        actions: [
          PopupMenuButton<AddCategoryBrandOptions>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onSelected: (AddCategoryBrandOptions result) {},
            itemBuilder: (BuildContext context) => <PopupMenuEntry<AddCategoryBrandOptions>>[
              PopupMenuItem<AddCategoryBrandOptions>(
                value: AddCategoryBrandOptions.SETTING,
                child: TextButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.list, color: Colors.black),
                      Text(
                        "Categories",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  onPressed: () async {
                    Get.back();
                    await Get.to(() => const SelectCategoryScreen());
                    storeController.startStream();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: Get.width,
                child: Row(
                  children: [
                    Expanded(child: GetBuilder<AddProductController>(builder: (controller) {
                      return SizedBox(
                        height: 100,
                        width: 55,
                        child: Semantics(
                            label: 'image_picker_example_picked_images',
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              key: UniqueKey(),
                              itemBuilder: (context, index) {
                                // Why network for web?
                                // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Semantics(
                                    label: 'image_picker_example_picked_image',
                                    child: ClipRRect(
                                      // borderRadius: BorderRadius.circular(50.0),
                                      child: Image.file(
                                        File(controller.imageFileList[index].path),
                                        fit: BoxFit.fill,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: controller.imageFileList.length,
                            )),
                      );
                    })),
                    Container(
                      height: 100,
                      margin: const EdgeInsets.all(4),
                      child: OutlinedButton(
                        onPressed: () async {
                          addProductController.selectImages();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.add,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      controller: addProductController.productName,
                      onChanged: (value) {},
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      validator: (v) {
                        if (v.toString().trim().isNotEmpty) {
                          return null;
                        } else {
                          return 'Please enter a valid name';
                        }
                      },
                      style: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(color: kPrimaryColor),
                          border: InputBorder.none,
                          labelStyle: TextStyle(color: kPrimaryColor),
                          labelText: "Product Name",
                          hintText: "Product Name",
                          icon: Icon(
                            Icons.short_text,
                            color: kPrimaryColor,
                          )),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      controller: addProductController.productBrandName,
                      onChanged: (value) {},
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      validator: (v) {
                        if (v.toString().trim().isNotEmpty) {
                          return null;
                        } else {
                          return 'Please enter a valid name';
                        }
                      },
                      style: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(color: kPrimaryColor),
                          border: InputBorder.none,
                          labelStyle: TextStyle(color: kPrimaryColor),
                          labelText: "Product brand Name",
                          hintText: "Product brand Name",
                          icon: Icon(
                            Icons.short_text,
                            color: kPrimaryColor,
                          )),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      minLines: 3,
                      maxLines: 3,
                      controller: addProductController.description,
                      onChanged: (value) {},
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (v) {
                        if (v.toString().trim().isNotEmpty) {
                          return null;
                        } else {
                          return 'Please enter a valid name';
                        }
                      },
                      style: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(color: kPrimaryColor),
                          border: InputBorder.none,
                          labelStyle: TextStyle(color: kPrimaryColor),
                          labelText: "Product Description",
                          hintText: "Product Description",
                          icon: Icon(
                            Icons.short_text,
                            color: kPrimaryColor,
                          )),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      controller: addProductController.price,
                      onChanged: (value) {},
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (v) {
                        if (v.toString().trim().isNotEmpty) {
                          return null;
                        } else {
                          return 'Please enter a valid name';
                        }
                      },
                      style: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),

                      // controller: authProvider.email,
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(color: kPrimaryColor),
                          border: InputBorder.none,
                          labelStyle: TextStyle(color: kPrimaryColor),
                          labelText: "Product Prices",
                          hintText: "Product Prices",
                          icon: Text("Prices")),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      controller: addProductController.quantity,
                      onChanged: (value) {},
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (v) {
                        if (v.toString().trim().isNotEmpty) {
                          return null;
                        } else {
                          return 'Please enter a valid name';
                        }
                      },
                      style: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),

                      // controller: authProvider.email,
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(color: kPrimaryColor),
                          border: InputBorder.none,
                          labelStyle: TextStyle(color: kPrimaryColor),
                          labelText: "Product Quantity",
                          hintText: "Product Quantity",
                          icon: Text("Quantity")),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: CustomBtn2(
                  text: "Submit",
                  onTap: () {
                    addProductController.submitProduct();
                  },
                  bgColor: kPrimaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void errorMessage({required Widget child}) {
    Get.defaultDialog(
        content: Column(
          children: [
            child,
          ],
        ),
        confirm: CustomBtn2(
          bgColor: kPrimaryColor,
          child: Text(
            "OK",
            style: themeData!.textTheme.bodyLarge!.copyWith(color: Colors.white),
          ),
          onTap: () {
            Get.back();
          },
        ));
  }

  Widget formLogicWidget() {
    String getString() {
      switch (extraDataType) {
        case ExtraDataType.GENERAL:
          // TODO: Handle this case.
          return "";
        case ExtraDataType.ProductSize:
          return "Size";
        case ExtraDataType.ProductColor:
          // TODO: Handle this case.

          return "Color";
      }
    }

    switch (extraDataType) {
      case ExtraDataType.GENERAL:
        // TODO: Handle this case.
        return Container();
      case ExtraDataType.ProductSize:
      case ExtraDataType.ProductColor:
        // TODO: Handle this case.
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextFormField(
                    onChanged: (value) {
                      switch (extraDataType) {
                        case ExtraDataType.GENERAL:
                          // TODO: Handle this case.
                          break;
                        case ExtraDataType.ProductSize:
                          // productSize.size = value;
                          break;

                        case ExtraDataType.ProductColor:
                          // productColor.color = value;
                          break;
                      }
                    },
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (v) {
                      if (v.toString().trim().isNotEmpty) {
                        return null;
                      } else {
                        return 'Please enter a valid name';
                      }
                    },
                    style: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),

                    // controller: authProvider.email,
                    decoration: InputDecoration(
                        hintStyle: const TextStyle(color: kPrimaryColor),
                        border: InputBorder.none,
                        labelStyle: const TextStyle(color: kPrimaryColor),
                        labelText: getString(),
                        hintText: getString(),
                        icon: const Icon(
                          Icons.short_text,
                          color: kPrimaryColor,
                        )),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextFormField(
                    onChanged: (value) {
                      switch (extraDataType) {
                        case ExtraDataType.GENERAL:
                          // TODO: Handle this case.
                          break;
                        case ExtraDataType.ProductSize:
                          // productSize.quantity = int.parse(value);
                          break;
                        case ExtraDataType.ProductColor:
                          // productColor.quantity = int.parse(value);

                          break;
                      }
                    },
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (v) {
                      if (v.toString().trim().isNotEmpty) {
                        return null;
                      } else {
                        return 'Please enter a valid name';
                      }
                    },
                    style: themeData!.textTheme.bodyLarge!.copyWith(color: kPrimaryColor),

                    // controller: authProvider.email,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: kPrimaryColor),
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: kPrimaryColor),
                        labelText: "Quantity",
                        hintText: "Quantity",
                        icon: Icon(
                          Icons.short_text,
                          color: kPrimaryColor,
                        )),
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }
}

// class ExtraDataWidget extends StatelessWidget {
//   const ExtraDataWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         children: [
//           Obx(() => GridView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 5.0,
//                   mainAxisSpacing: 0.0,
//                   childAspectRatio: 1.5,
//                 ),
//                 itemCount: storeController.productExtraData.where((element) => element.extraDataType == ExtraDataType.ProductColor).toList().length,
//                 itemBuilder: (context, index) {
//                   List<ProductExtraData> colors = storeController.productExtraData.where((element) => element.extraDataType == ExtraDataType.ProductColor).toList();
//                   var color = ProductColor.fromMap(colors[index].data!);
//                   return GestureDetector(
//                     onDoubleTap: () {
//                       // storeController.productExtraData.value.removeAt(index);
//                     },
//                     child: Column(
//                       children: [
//                         Table(
//                           children: [
//                             TableRow(children: [
//                               const Text("Colors:"),
//                               Text("${color.color}"),
//                             ])
//                           ],
//                         ),
//                         Table(
//                           children: [
//                             TableRow(children: [
//                               const Text("Quantity"),
//                               Text("${color.quantity}"),
//                             ])
//                           ],
//                         ),
//
//                         // Expanded(
//                         //   child: Column(
//                         //     children: [
//                         //       const Expanded(child: Text("Colors:"),),
//                         //       Expanded(child: Text("${color.color}")),
//                         //     ],
//                         //   ),
//                         // ),
//                         // Text("Quantity: ${color.quantity}"),
//                         const Divider(
//                           color: kPrimaryColor,
//                           thickness: 1.0,
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               )),
//           Obx(() => GridView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 5.0,
//                   mainAxisSpacing: 0.0,
//                   childAspectRatio: 1.5,
//                 ),
//                 itemCount: storeController.productExtraData.where((element) => element.extraDataType == ExtraDataType.ProductSize).toList().length,
//                 itemBuilder: (context, index) {
//                   List<ProductExtraData> sizes = storeController.productExtraData.where((element) => element.extraDataType == ExtraDataType.ProductSize).toList();
//                   var size = ProductSize.fromMap(sizes[index].data!);
//                   return GestureDetector(
//                     onDoubleTap: () {
//                       // storeController.productExtraData.value.removeAt(index);
//                     },
//                     child: Column(
//                       children: [
//                         Table(
//                           children: [
//                             TableRow(children: [
//                               const Text("Size:"),
//                               Text("${size.size}"),
//                             ])
//                           ],
//                         ),
//                         Table(
//                           children: [
//                             TableRow(children: [
//                               const Text("Quantity"),
//                               Text("${size.quantity}"),
//                             ])
//                           ],
//                         ),
//                         const Divider(
//                           color: kPrimaryColor,
//                           thickness: 1.0,
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               )),
//         ],
//       ),
//     );
//   }
// }

// class CategoryWidget extends StatelessWidget {
//   const CategoryWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Padding(
//           padding: const EdgeInsets.all(12),
//           child: Container(
//             decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular(5)),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       "Category",
//                       style: themeData!.textTheme.bodyText2,
//                     ),
//                   ),
//                   DropdownButton<String>(
//                     value: storeController.categoryDropdownValue.value,
//                     icon: const Icon(Icons.arrow_drop_down),
//                     iconSize: 24,
//                     elevation: 16,
//                     style: const TextStyle(color: Colors.red, fontSize: 18),
//                     underline: Container(
//                       height: 2,
//                       color: Colors.deepPurpleAccent,
//                     ),
//                     onChanged: (String? data) {
//                       if (data != null || data != "") {
//                         var currentCategory = storeController.categories.firstWhereOrNull((element) => element.category.toString() == data);
//
//                         if (currentCategory != null) {
//                           storeController.startCategoryBrandStream(currentCategory);
//                           // storeController.categoryDropdownValue.value = data.toString();
//                         }
//                       }
//                     },
//                     items: storeController.categoryList.map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
//
// class CategoryBrandsWidget extends StatelessWidget {
//   const CategoryBrandsWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Padding(
//           padding: const EdgeInsets.all(12),
//           child: Container(
//             decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular(5)),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       "Brand",
//                       style: themeData!.textTheme.bodyText2,
//                     ),
//                   ),
//                   Expanded(
//                     child: DropdownButton<String>(
//                       value: storeController.brandDropdownValue.value,
//                       icon: const Icon(Icons.arrow_drop_down),
//                       iconSize: 24,
//                       elevation: 16,
//                       style: const TextStyle(color: Colors.red, fontSize: 18),
//                       underline: Container(
//                         height: 2,
//                         color: Colors.deepPurpleAccent,
//                       ),
//                       onChanged: (String? data) {
//                         if (data != null || data != "") {
//                           storeController.brandDropdownValue.value = data!;
//                           // addProductController.getBrandDropDownItem(data!.trim().toString());
//                         }
//                       },
//                       items: storeController.brandList.map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
