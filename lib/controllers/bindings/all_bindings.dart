import 'package:mooweapp/export_files.dart';


class AllBindings extends GetxController {
  static AllBindings instance = Get.find();
  @override
  void onInit() {
    Get.put(NotificationController());
    Get.put(PermissionController());
    Get.put(CollectionController());
    Get.put(NavController());
    Get.put(SandboxPaymentMethodController());
    Get.put(ProductsController());
    Get.put(CallSignalingController());
    Get.put(ContactServices());
    Get.put(DatabaseHelper());
    Get.put(CartController());
    // Get.put(UserController());
    Get.put(ExchangeMoneyController());
    Get.put(ContractController());
    Get.put(Storage());
    Get.put(QRCodeController());
    Get.put(ChatServices());
    Get.put(AddPaymentMethodController());

    super.onInit();
  }

  void initializeControllersAfterLogin(){
    if (kDebugMode) {
      print("initializeControllersAfterLogin");
    }
    Get.put(PaymentsController());

    Get.put(ApiController());
    Get.put(ChatRoomController());
    Get.put(AffiliateController());
    Get.put(TransactionServices());
    Get.put(UserProfileController());
    Get.put(GrouchChatController());
    Get.put(AddressController());
    Get.put(BusinessAcceptPaymentsController());
    Get.put(BusinessServices());
    Get.put(AddProductController());
    Get.put(StoreController());
  }
}


class BusinessBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayBillToBusinessController>(() => PayBillToBusinessController());
  }
}
class BusinessAcceptPaymentBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessAcceptPaymentsController>(() => BusinessAcceptPaymentsController());
  }
}