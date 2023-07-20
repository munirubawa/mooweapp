import 'package:mooweapp/export_files.dart';

// NotificationController notificationController = NotificationController.instance;
// AppController appController = AppController.instance;
// UserController userController = UserController.instance;
ProductsController productsController = ProductsController.instance;
CartController cartController = CartController.instance;
ExchangeMoneyController exchangeController = ExchangeMoneyController.instance;
PaymentsController paymentsController = PaymentsController.instance;
ChatRoomController chatRoomController = ChatRoomController.instance;
CollectionController momoController = CollectionController.instance;
// AddressController addressController = AddressController.instance;
StoreController storeController = StoreController.instance;
AffiliateController affiliateController = AffiliateController.instance;
ApiController apiController = ApiController.instance;
NavController navController = NavController.instance;
DatabaseHelper dbHelper = DatabaseHelper.instance;
AddPaymentMethodController addPaymentMethodController = AddPaymentMethodController.instance;
SandboxPaymentMethodController sandboxPaymentMethodController = SandboxPaymentMethodController.instance;
ContractController contractController = ContractController.instance;
UserProfileController userProfileController = UserProfileController.instance;
PermissionController permissionController = PermissionController.instance;
QRCodeController qrCodeController = QRCodeController.instance;
AddProductController addProductController = AddProductController.instance;
FirebaseMessaging fcm = FirebaseMessaging.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
AllBindings allBindings = AllBindings.instance;
CallHistoryController callHistoryController = CallHistoryController.instance;
GrouchChatController groupChatController  = GrouchChatController.instance;
BusinessAcceptPaymentsController acceptPaymentsController = BusinessAcceptPaymentsController.instance;
// UserChatRoomController userChatRoomController = UserChatRoomController.instance;
UserPaymentMethod userPaymentMethod = UserPaymentMethod();

ThemeData? themeData;
FirebaseAuth auth = FirebaseAuth.instance;
ChatServices chatServices = ChatServices.instance;
EnumServices enumServices = EnumServices() ;
FirebaseStorage fireStorage = FirebaseStorage.instance;
CallSignalingController signal = CallSignalingController.instance;

MemberModel memberModel = MemberModel();
RxString deviceToken = RxString("");


// Location location = Location();
// LocationData? locationData;
DocumentSnapshot? driverSnapshot;
// const GOOGLE_MAPS_API_KEY = "AIzaSyBEVEevHU-FiExSh7j6Z6I6HEGVdDJFAbc";
// String serverToken = "AAAARLp3STA:APA91bEoPwHxZmO35j50UaZEFGQxay6-zlnR7-Iv2RqiAZdMBWmCSMpi7GuRbTTlTCAOPoAWgvkh5rK5yAn2RrTdiNavj9vfSEaBehUeHxv7ja5I-WWND9lavkrD-6wTJVR2eP-OFqt0";
// StreamSubscription<Position>? homeTabPageStreamSubscriptions;
// StreamSubscription<Position>? newRideStreamSubscriptions;

const COLOR_DARK_BLUE = Color.fromRGBO(20, 25, 45, 1.0);

final box = GetStorage();
Chat initialChat = Chat();
DocumentSnapshot? remoteMember ;
List<DocumentSnapshot>  groupOrProjectMembers = [];
TransactionServices transactionService = TransactionServices.instance;
// var selectedCountryInfo = CountryInfo();
Directory? appDocDir;
// Storage storage = Storage();
Storage storage = Storage.instance;
AuthController? authController;
ContactServices contactServices = ContactServices.instance;

final Future<FirebaseApp> initialization = Firebase.initializeApp();
// CountryServices countryServices = CountryServices();
// ContactServices countryServices = ContactServices.instance;
double imageRadius = Get.width * 0.05;
bool isDriverAcceptingPassengers = true;
// final assetAudioPlayerMoney = AssetsAudioPlayer.newPlayer();
// final assetAudioPlayerCall = AssetsAudioPlayer.newPlayer();
// final assetAudioPlayerRideRequest = AssetsAudioPlayer.newPlayer();
bool isCurrencySearched = false;
BusinessServices businessServices = BusinessServices.instance;
// var businessContactServices = BusinessContactServices();
// Contract contract =  Contract();
TextEditingController chatScreenTextController = TextEditingController();
Function()? runGroupCallUpdateWhenTerminated = (){};
var selectedCountryInfo = {};

ContractModel conModel = ContractModel();

List<ChatRoom> currentChats = [];
List<UserChatRoom> userChatRoom = [];

extension PrettyJson on Map<String, dynamic> {
  String toPrettyString() {
    var encoder = const JsonEncoder.withIndent("");
    return encoder.convert(this);
  }
}


// const kPrimaryColor = Colors.blueAccent;
const kPrimaryColor = Color(0xFF12792E);