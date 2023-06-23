import 'package:mooweapp/export_files.dart';

class PayBillToBusinessController extends GetxController {
  static PayBillToBusinessController instance = Get.find();
  final geo = GeoFlutterFire();
  BehaviorSubject<double> radius = BehaviorSubject.seeded(25);


  @override
  void onInit() {
    super.onInit();
  }

  RxList<Business> stores = RxList<Business>([]);
  RxList<Business> searchResults = RxList<Business>([]);
  String collection = "businesses";
  Rx<MarketAppBarActions> marketAppBarActions = MarketAppBarActions.CANCEL_SEARCH.obs;
  RxString searchWord = RxString("");
  @override
  onReady() {
    super.onReady();
    stores.bindStream(getAllServiceBasedBusinesses());
    ever(searchWord, (callback) => search());
    ever(searchResults, (callback) => filterSearchResult());
  }

  // Stream<List<Business>> getAllServiceBasedBusinesses() => firebaseFirestore.collection(collection).snapshots().map((query) => query.docs.map((item) => Business.fromSnap(item)).toList());
  Stream<List<Business>> getAllServiceBasedBusinesses() => firebaseFirestore.collection(collection)
      .where("userBusinessType", isEqualTo: EnumToString.convertToString(UserBusinessType.ACCEPT_PAYMENT_SERVICE)).snapshots().map((query) => query.docs.map((item) => Business.fromSnap(item)).toList());

  // Stream<List<ProductPayload>> getSearchProducts() =>
  //     firebaseFirestore.collection(collection).where(field).snapshots().map((query) =>
  //         query.docs.map((item) => ProductPayload.fromSnap(item)).toList());
  void changeSearchBar(MarketAppBarActions action) {
    marketAppBarActions.value = action;
    if(action == MarketAppBarActions.CANCEL_SEARCH) {
      stores.bindStream(getAllServiceBasedBusinesses());
    }
  }

  void search() {
    if (searchWord.value.isNotEmpty) {
      String letter = searchWord.value.substring(0, 1);
      firebaseFirestore.collection(collection).where("search", isEqualTo: letter.toUpperCase()).get().then((query) {
        searchResults.value = query.docs.map((item) => Business.fromSnap(item)).toList();
        print("searchResults.length");
        print(searchResults.length);
      });
    }else {
      stores.bindStream(getAllServiceBasedBusinesses());
    }
  }

  void filterSearchResult() {
    searchResults.value.retainWhere((e) => e.businessName!.toLowerCase().contains(searchWord.value.toLowerCase()));
    stores.value = searchResults.value;
  }
}
