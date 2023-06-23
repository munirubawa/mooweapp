import 'package:mooweapp/export_files.dart';
class SelectCategoryScreen extends StatelessWidget {
  const SelectCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("category", style: themeData!.textTheme.headline5!.copyWith(color: Colors.white),),
        actions: [
          IconButton(onPressed: (){
            _categoryAlert();
          }, icon: const Icon(Icons.add))
        ],
      ),
      body:  Obx(()=>GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 3.9,
          padding: const EdgeInsets.all(2),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 10,
          children: storeController.categories.map((StoreCategory category) {
            return Card(
              child: ListTile(
                onTap: () async {
                  storeController.currentCategory = category;
                  storeController.startCategoryBrandStream(category);
                  storeController.productPayload.category = category.toString();
                  print(category.category.toString());

                  // Get.back();
                 await Get.to(()=> const SelectBrandScreen());

                },
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(category.category.toString()),
                ),
              ),
            );
          }).toList())),
    );
  }

  void _categoryAlert() {
    StoreCategory category = StoreCategory();
    Get.defaultDialog(
      title: "Add Category",
      barrierDismissible: false,
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular
                (5)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextFormField(
                  onChanged: (value) {
                    category.category = value;
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
                  style: themeData!.textTheme.headline5!.copyWith(color: kPrimaryColor),

                  // controller: authProvider.email,
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(color: kPrimaryColor),
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: kPrimaryColor),
                      labelText: "Category Name",
                      hintText: "Category Name",
                      icon: Icon(
                        Icons.short_text,
                        color: kPrimaryColor,
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
      actions:    [
        SizedBox(
          height: 55,
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomBtn2(onTap: (){
                Get.back();
              }, child: Text("Close",style: themeData!.textTheme.bodyLarge!.copyWith(color: Colors.white),), bgColor:
              kPrimaryColor,),
              CustomBtn2(
                  onTap: (){
                Get.back();
                // addProductController.addCategory({"category": addProductController.category.text.trim()});
                // addProductController.category.clear();
                if(category.category != null && category.category!.isNotEmpty) {
                  storeController.addCategory(category);
                } else {
                  Get.snackbar("Brand", "Fail to add");
                }

              }, child: Text("Submit", style: themeData!.textTheme.bodyLarge!.copyWith(color: Colors.white),), bgColor:
              kPrimaryColor,),
            ],
          ),
        )
      ],
    );
  }
}

class SelectBrandScreen extends StatelessWidget {
  const SelectBrandScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("Brand", style: themeData!.textTheme.headline5!.copyWith(color: Colors.white),),
        actions: [
          IconButton(onPressed: (){
            _brandAlert();
          }, icon: const Icon(Icons.add))
        ],
      ),
      body:  Obx(()=>GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 3.9,
          padding: const EdgeInsets.all(10),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 0,
          children: storeController.brands.map((Brand brand) {
            return Card(color: Colors.white.withOpacity(0.7),
              child: ListTile(
                onTap: (){
                  storeController.productPayload.brand = brand.toString();
                  print(brand.brand.toString());
                },
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(brand.brand.toString()),
                ),
              ),
            );
          }).toList())),
    );
  }

  void _brandAlert() {
    Brand brand = Brand();
    Get.defaultDialog(
      title: "Add Brand",
      barrierDismissible: false,
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular
                (5)),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextFormField(
                  onChanged: (value) {
                    brand.brand = value;
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
                  style: themeData!.textTheme.headline5!.copyWith(color: kPrimaryColor),

                  // controller: authProvider.email,
                  decoration: const InputDecoration(
                      hintStyle: TextStyle(color: kPrimaryColor),
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: kPrimaryColor),
                      labelText: "Brand Name",
                      hintText: "Brand Name",
                      icon: Icon(
                        Icons.short_text,
                        color: kPrimaryColor,
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        SizedBox(
          height: 55,
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomBtn2(onTap: (){
                Get.back();
              }, child: Text("Close",style: themeData!.textTheme.bodyLarge!.copyWith(color: Colors.white),), bgColor:
              kPrimaryColor,),
              CustomBtn2(
                onTap: (){
                  Get.back();
                  // addProductController.addCategory({"category": addProductController.category.text.trim()});
                  // addProductController.category.clear();
                  if(brand.brand != null && brand.brand!.isNotEmpty) {
                    storeController.addBrand(brand);
                  } else {
                    Get.snackbar("Brand", "Fail to add");
                  }

                }, child: Text("Submit", style: themeData!.textTheme.bodyLarge!.copyWith(color: Colors.white),), bgColor:
              kPrimaryColor,),
            ],
          ),
        )
      ],
    );
  }
}