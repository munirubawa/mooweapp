import 'package:mooweapp/export_files.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();
  RxDouble totalCartPrice = 0.0.obs;

  RxList<ProductPayload> cart = RxList([]);
  Map<String, dynamic> checkOutCart = {};
  String shippingAddress = "";
  String shippingFee = "";

  @override
  void onReady() {
    ever(cart, (callback) => changeCartTotalPrice());
    ever(cart, (callback) => saveCart());
    // ever(cart, (callback) => checkOutOrder());
    retrieveCard();
    super.onReady();
  }

  void retrieveCard() {
    List<dynamic> retrievedData = box.read("cart") ?? [];
    if (kDebugMode) {
      print(retrievedData);
    }
    Iterable<ProductPayload> cartData = retrievedData.map((e) => ProductPayload.fromMap(e));
    cart.value = cartData.toList();

    Map<String, dynamic> checkOutCartData = box.read("checkOutCart") ?? {};
    if (kDebugMode) {
      print("retrieveCardcheckOutCartData");
      print(checkOutCartData);
    }

    checkOutCart = checkOutCartData;
  }

  void deleteItemCheckOutOrder(ProductPayload product) {
    checkOutCart.remove(product.id);
    if (storesPath.containsKey(product.storeId)) {
      if (storesPath[product.storeId] == 1) {
        storesPath.remove(product.storeId);
      } else {
        storesPath[product.storeId!] = storesPath[product.storeId!] - 1;
      }
    }
    if (kDebugMode) {
      print("deleteItemCheckOutOrder");
      print(storesPath);
      print(storesPath.keys);
    }
  }

  void deleteItemAllCheckOutOrder() {
    checkOutCart.clear();
  }

  void saveCart() {
    List<Map<String, dynamic>> cartData = cart.value.map((e) => e.toMap()).toList();
    box.write("cart", cartData);
  }

  Map<String, dynamic> storesPath = {};
  void addProductToCart(ProductPayload product) {
    ProductPayload newProdud = product.copyWith(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      quantity: 1,
    );
    // product.id = DateTime.now().microsecondsSinceEpoch.toString();
    // product.quantity = 1;
    if (kDebugMode) {
      print("newProdud.toMap()");
      // print(product.toMap());
    }
    if (storesPath[newProdud.storeId!] == null) {
      print("new key not found");
      storesPath.addAll({newProdud.storeId!: 1});
    } else {
      print("store key found");
      //TODO: count the number of items in cart
      storesPath[newProdud.storeId!] = storesPath[newProdud.storeId!] + 1;
    }
    cart.add(newProdud);
    checkOutCart[newProdud.id.toString()] = {
      checkOutModel.storeId: newProdud.storeId,
      checkOutModel.itemId: newProdud.reference!.id,
      checkOutModel.price: newProdud.price,
      checkOutModel.buyerPrice: newProdud.buyerPrice,
      checkOutModel.buyerCurrencyCode: newProdud.buyerCurrencyCode,
      checkOutModel.buyerCurrencySign: newProdud.buyerCurrencySign,
      checkOutModel.currencyCode: newProdud.currencyCode,
      checkOutModel.currencySign: newProdud.currencySign,
    };
    saveCheckOutOrder();
    if (kDebugMode) {
      print("addProductToCart");
      print(storesPath);
      print(storesPath.values);
      storesPath.forEach((value, key) {
        print(value);
        print(key);
      });

    }
  }

  void saveCheckOutOrder() {
    box.write("checkOutCart", checkOutCart);
  }

  bool processCheckOutProcess = false;
  bool addShippingAddress() {
    if (addressController.address.value.isNotEmpty) {
      if (addressController.state.value.isNotEmpty) {
        if (addressController.city.value.isNotEmpty) {
          if (addressController.zip.value.isNotEmpty) {
            cartController.shippingAddress = "${addressController.address.value}, ${addressController.city.value} ${addressController.state.value} ${addressController.zip.value}";
            addressController.isAddressSelected.value = true;
          } else {
            showToastMessage(msg: "Zip is empty");
          }
        } else {
          showToastMessage(msg: "City is empty");
        }
      } else {
        showToastMessage(msg: "State is empty");
      }
    } else {
      showToastMessage(msg: "Address is empty");
    }
    return addressController.isAddressSelected.value;
  }

  Future<void> changeCartTotalPrice() async {
    print("totalCartPrice.value");

    totalCartPrice.value = 0.0;
    if (cart.value.isNotEmpty) {
      for (var cartItem in cart.value) {
        totalCartPrice.value += cartItem.buyerPrice;
      }
    }
  }
}

CheckOutModel checkOutModel = CheckOutModel();

class CheckOutModel {
  String storeId = "storeId";
  String itemId = "itemId";
  String price = "price";
  String buyerPrice = "buyerPrice";
  String buyerCurrencyCode = "buyerCurrencyCode";
  String buyerCurrencySign = "buyerCurrencySign";
  String currencySign = "currencySign";
  String currencyCode = "currencyCode";
}
