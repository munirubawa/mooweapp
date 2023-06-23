import 'package:mooweapp/export_files.dart';

class ProductsController extends GetxController {
  static ProductsController instance = Get.find();
  RxList<ProductPayload> products = RxList<ProductPayload>([]);
  RxList<ProductPayload> searchResults = RxList<ProductPayload>([]);
  String collection = "marketPlace";
  Rx<MarketAppBarActions> marketAppBarActions = MarketAppBarActions.CANCEL_SEARCH.obs;
  RxString searchWord = RxString("");
  RxBool isLocalMemberSet = RxBool(false);
  @override
  onReady() {
    super.onReady();
    // products.bindStream(getAllProducts());
    ever(searchWord, (callback) => search());
    ever(searchResults, (callback) => filterSearchResult());
    // ever(products, (callback) => updateProducts());
  }

  void inItProducts(){
    if(isLocalMemberSet.value) {
      isLocalMemberSet.value = false;
      productsController.products.bindStream(productsController.getAllProducts());
    }
  }

  Stream<List<ProductPayload>> getAllProducts() => firebaseFirestore.collection(collection).snapshots().map((query){
    return query.docs.map((item){
      return ProductPayload.fromSnap(item) ;
    }).toList();
  });

  void changeSearchBar(MarketAppBarActions action) {
    marketAppBarActions.value = action;
    if (action == MarketAppBarActions.CANCEL_SEARCH) {
      products.bindStream(getAllProducts());
    }
  }

  Future<ProductPayload> updateProducts(ProductPayload load) async {
    ProductPayload? item;
    if (load.currencyCode != chatServices.localMember!.get(memberModel.currencyCode)) {
      var date = Timestamp.now().toDate().toLocal();

      // transactionService.localCurrency = chatServices.localMember!.get(memberModel.currencyCode);
      // transactionService.remoteCurrency = load.currencyCode ;


      String currencyKey = "${chatServices.localMember!.get(memberModel.currencyCode)}_${load.currencyCode}${date.year}${date.month}${date.day}${date.hour}";
      if (kDebugMode) {
        print("currencyKey");
        print(currencyKey);
        print(Timestamp.now().toDate());
        print("${date.year}${date.month}${date.day}");
      }
      if (box.read(currencyKey) == null) {
        await  exchangeController.productCurrencyExchangeConverter(localCurrency: chatServices.localMember!.get(memberModel.currencyCode), remoteCurrency: load.currencyCode!).then((value) {
          load.buyerPrice = (value["storeExchangeRate"] * load.price);
          load.buyerCurrencyCode = chatServices.localMember!.get(memberModel.currencyCode);
          load.buyerCurrencySign = chatServices.localMember!.get(memberModel.currencySign);
          box.write(currencyKey, value);
          if (kDebugMode) {
            print("productCurrencyExchangeConverter");
            print(value);
          }
          item = load;
        });
      } else {
        if (kDebugMode) {
          print("currencyKey from box ${box.read(currencyKey)}");
        }

        Map<String, dynamic> data = box.read(currencyKey);
        load.buyerPrice = (data["storeExchangeRate"] * load.price);
        load.buyerCurrencyCode = chatServices.localMember!.get(memberModel.currencyCode);
        load.buyerCurrencySign = chatServices.localMember!.get(memberModel.currencySign);

        item = load;

      }
    } else {
      load.buyerPrice = load.price!;
      load.buyerCurrencyCode = chatServices.localMember!.get(memberModel.currencyCode);
      load.buyerCurrencySign = chatServices.localMember!.get(memberModel.currencySign);

      item = load;

    }

    return item!;
  }

  ProductPayload setProductPriceAndCurrency(ProductPayload product) {
    return product;
  }

  void search() {
    if (searchWord.value.isNotEmpty) {
      String letter = searchWord.value.substring(0, 1);
      firebaseFirestore.collection(collection).where("searchName", isEqualTo: letter.toUpperCase()).get().then((query) {
        searchResults.value = query.docs.map((item) => ProductPayload.fromSnap(item)).toList();
        print("searchResults.length");
        print(searchResults.length);
      });
    } else {
      products.bindStream(getAllProducts());
    }
  }

  void filterSearchResult() {
    searchResults.value.retainWhere((e) => e.name!.toLowerCase().contains(searchWord.value.toLowerCase()));
    products.value = searchResults.value;
  }
}
