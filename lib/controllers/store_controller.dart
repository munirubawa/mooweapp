import 'package:mooweapp/export_files.dart';
class StoreController extends GetxController {
  static StoreController instance = Get.find();
  RxList<StoreCategory> categories = RxList<StoreCategory>([]);
  RxList<Brand> brands = RxList<Brand>([]);
  String collection = "marketPlace";
  Business? business;
  var storeBusiness = Business().obs;
  ProductPayload productPayload = ProductPayload();
  StoreCategory? currentCategory;
  List<String> categoryList = [];
  List<String> brandList = [];
  RxList<ProductExtraData> productExtraData = RxList<ProductExtraData>([]);
  RxList<ProductPayload> storeProducts = RxList<ProductPayload>([]);
  RxSet<DocumentSnapshot> storeOrders = RxSet<DocumentSnapshot>();



  List<Map<String, dynamic>> productExtraDataToMap = [];
  RxString categoryDropdownValue = 'Tom Cruise'.obs;
  RxString brandDropdownValue = 'Other '.obs;

  @override
  onReady() {
    productExtraData.clear();
    super.onReady();
  }
  
 
  Stream<List<TransactionPayload>> getStoreOrders() =>
      firebaseFirestore.doc(storeBusiness.value.snapshot!.reference.path).collection("orders").orderBy("time", descending: true).snapshots().map((query) => query.docs.map((item) => TransactionPayload.fromSnap(item))
          .toList());
  RxList<TransactionPayload> storeTransactions = RxList([]);
  RxDouble accountBalance = RxDouble(0.0);
  @override
  void onInit() {

    ever(storeTransactions, (callback) => userBalance());
    super.onInit();
  }

  getStoreTransaction(){
    storeTransactions.bindStream(getAllStoreTransaction());
  }
  Stream<List<TransactionPayload>> getAllStoreTransaction() =>
      firebaseFirestore.collection(storeBusiness.value.cardTransactionPath!).orderBy("time", descending: true).snapshots().map((query) => query.docs.map((item) => TransactionPayload.fromSnap(item))
          .toList());

  Future<void> userBalance() async {
    double credit = storeTransactions.value
        .where((element) => element.payloadType == TransactionPayloadType.TRANSACTION)
        .map((item) => MooweTransactions.fromJson(item.data).credit)
        .fold(0.0, (sum, item) => sum + item!.toDouble());
    double debit = storeTransactions.value
        .where((element) => element.payloadType == TransactionPayloadType.TRANSACTION)
        .map((item) => MooweTransactions.fromJson(item.data).debit)
        .fold(0.0, (sum, item) => sum + item!.toDouble());
    // transactionAmount.value  = (debit - credit).toDouble() ;
    accountBalance.value = (debit - credit);
    print(accountBalance);
    print("accountBalance.value");
  }

  void getStoreFromDatabase(String storeId){
    firebaseFirestore.collection("businesses").doc(storeId).get().then((value){
      if(value.exists) {
        storeBusiness.value =  Business.fromSnap(value);
        storeProducts.bindStream(storeProductFromMarketPlace());
      }
    });
  }


  void startCategoryBrandStream(StoreCategory category){
    brands.stream.listen((event) {
    }).onData((data) {
      if( data.isNotEmpty){
        print("NOT EMPTY");
        brands.value = data;
        brandList  = data.map((element) => element.brand!).toList();
        brandList.insert(0, "Select ${category.category} Brand");
        brandDropdownValue.value = brandList.first;
      } else {
        print("EMPTY");
        brandList.clear();
        brandList  = data.map((element) => element.brand!).toList();
        brandList.insert(0, "No Brand");
        brandDropdownValue.value = brandList.first;
      }
    });
    brandList.clear();
    brands.bindStream(getAllBrand(category));
    categoryDropdownValue.value = category.category.toString();

  }


  void startStream(){
    categories.bindStream(getAllCategory());
    storeProducts.bindStream(storeProductFromMarketPlace());
    getCategoryList();

    if(!chatServices.localMember!.get(memberModel.hasAStore)!) {
      chatServices.localMember!.reference.update({
        memberModel.hasAStore: true,
        memberModel.storePath: storeBusiness.value.snapshot!.id,
      });
    }

  }
  void getCategoryList(){
    categoryList = categories.map((element) => element.category!).toList();
    if(categoryList.isNotEmpty) {
      print(categoryList);
      categoryList.insert(0, "Select Category");
      categoryDropdownValue.value = categoryList.first;
    } else {
      print(categoryList);
      categoryList.insert(0, "No Category");
      categoryDropdownValue.value = categoryList.first;
    }

  }
  void addBrand(Brand brand){
    firebaseFirestore.collection("${currentCategory!.reference!.path}/brands").add(brand.toMap());
  }
  void addCategory(StoreCategory category){
    firebaseFirestore.collection("${storeBusiness.value.snapshot!.reference.path}/categories").add(category.toMap());
  }

  Stream<List<StoreCategory>> getAllCategory() =>
      firebaseFirestore.collection("${storeBusiness.value.snapshot!.reference.path}/categories").snapshots().map((query) =>
          query.docs.map((item) => StoreCategory.fromSnap(item)).toList());

  Stream<List<ProductPayload>> storeProductFromMarketPlace() =>
      firebaseFirestore.collection("marketPlace").where("storeId", isEqualTo: storeBusiness.value.snapshot!.id)
          .snapshots().map(
              (query) =>
          query.docs.map((item) => ProductPayload.fromSnap(item)).toList());

  Stream<List<Brand>> getAllBrand(StoreCategory category) =>
      firebaseFirestore.collection("${category.reference!.path}/brands").snapshots().map((query) =>
          query.docs.map((item) => Brand.fromSnap(item)).toList());
}







class Brand{
  String? brand;
  DocumentReference? reference;

  Brand({
    this.brand,
    this.reference,
  });

  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
    };
  }

  factory Brand.fromMap(Map<String, dynamic> map) {
    return Brand(
      brand: map['brand'] as String,
    );
  }

  factory Brand.fromSnap(DocumentSnapshot snapshot) {
    return Brand(
      reference : snapshot.reference,
      brand: snapshot.get("brand"),
    );
  }
}