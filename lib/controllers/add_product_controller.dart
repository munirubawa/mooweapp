import 'package:mooweapp/export_files.dart';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mooweapp/Screens/MarketPlace/constants/firebase.dart';
// import 'package:mooweapp/Screens/MarketPlace/models/product_payload.dart';
// import 'package:mooweapp/classes/business.dart';
// import 'package:mooweapp/classes/transactions.dart';
// import 'package:mooweapp/components/showLoading.dart';
// import 'package:mooweapp/controllers.dart';
// import 'package:mooweapp/global.dart';
// import 'package:path/path.dart' as Path;
class AddProductController extends GetxController {
  static AddProductController instance = Get.find();

  List<XFile> imageFileList = <XFile>[].obs;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController productName = TextEditingController();
  final TextEditingController productBrandName = TextEditingController(text: "Other");
  final TextEditingController description = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController category = TextEditingController();
  final TextEditingController brand = TextEditingController();
  final TextEditingController quantity = TextEditingController();

  Rx<Business> business = Rx<Business>(Business());





  @override
  void onInit() {
    ever(business, (callback) {
      addProductController.getCategories();
      addProductController.getBrands();

      storeController.storeBusiness.value = business.value;
      storeController.startStream();
      storeController.getStoreTransaction();
    });

    super.onInit();
  }

  void selectImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      imageFileList = images;
    }
    update();
  }

  void setState(Function()? state) {
    state!();
    update();
  }

  // Default Drop Down Item.
  RxString categoryDropdownValue = 'Other'.obs;

  // To show Selected Item in Text.
  String holder = '';

  List<String> categoryList = [];

  void getCategoryDropDownItem(String? value) {
    categoryDropdownValue.value = value!;
  }

  void addCategory(Map<String, dynamic> data) {
    business.value.snapshot!.reference.collection("categories").add(data);
  }

  void getCategories() async {
    categoryList.clear();
    categoryList.add("Select Category");
    List<String> catigories = await business.value.snapshot!.reference
        .collection("categories")
        .get()
        .then((value) => value.docs.map((e) => e.get("category").toString()).toList());
    categoryList.addAll(catigories);
    categoryDropdownValue.value = "Select Category";
  }

  // Default Drop Down Item.
  RxString brandDropdownValue = 'Leonardo DiCaprio'.obs;

  // To show Selected Item in Text.
  String brandHolder = '';

  List<String> brandList = [];

  void getBrandDropDownItem(String? value) {
    brandDropdownValue.value = value!;
  }

  void addBrand(Map<String, dynamic> data) {
    business.value.snapshot!.reference.collection("brands").add(data);
  }

  void getBrands() async {
    brandList.clear();
    brandList.add("Select Brand");
    List<String> _brand = await business.value.snapshot!.reference
        .collection("brands")
        .get()
        .then((value) => value.docs.map((e) => e.get("brand").toString()).toList());
    brandList.addAll(_brand);

    brandDropdownValue.value = "Select Brand";
  }

  List<String> uploadedImages = [];
  submitProduct() async {
    if (productName.text.isNotEmpty &&
        price.text.isNotEmpty &&
        price.text.isNotEmpty &&
        storeController.brandDropdownValue.isNotEmpty &&
        storeController.brandDropdownValue.value.toString() != "Select Brand" &&
        storeController.categoryDropdownValue.isNotEmpty &&
        storeController.categoryDropdownValue.value.toString() != "Select Category") {
      showLoading();

      if (imageFileList.isNotEmpty) {
        for (var element in imageFileList) {
          uploadedImages.add(await authController!.chatUploader(
            file: File(element.path),
            path: basename(element.path),
            contentType: 'image/png',
          ));
        }
      }
      if (uploadedImages.isNotEmpty && uploadedImages.length == imageFileList.length) {
        ProductPayload productModel = ProductPayload();
        productModel.name = productName.text.trim();
        productModel.description = description.text.trim();
        productModel.price = double.parse(price.text.trim());
        productModel.quantity = int.parse(quantity.text.trim());
        productModel.brand = productBrandName.text.trim();
        productModel.category = storeController.categoryDropdownValue.trim().trim();
        productModel.images = uploadedImages;
        productModel.storeId = storeController.storeBusiness.value.snapshot!.id.toString();
        productModel.productExtraData = storeController.productExtraDataToMap;
        productModel.currencySign = storeController.storeBusiness.value.currencySign;
        productModel.currencyCode = storeController.storeBusiness.value.currencyCode;


        FirebaseFirestore.instance.collection("marketPlace").add(productModel.toMap());
        uploadedImages.clear();
        imageFileList.clear();

        productName.text = "";
        productBrandName.text = "";
        description.text = "";
        price.text = "";
        quantity.text = "";

        // storeController.brandDropdownValue.value = "Select Brand";
        // storeController.categoryDropdownValue.value = "Select Category";
        storeController.productExtraData.clear();
        setState(() => null);
        dismissLoadingWidget();
        Get.back();
        Get.snackbar("Product", "New Product was added", backgroundColor: Colors.green);
      }
    } else {
      Get.snackbar("Required", "All fields are required", backgroundColor: Colors.white);
    }
  }
}