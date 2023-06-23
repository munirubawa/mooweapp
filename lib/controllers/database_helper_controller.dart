import 'package:mooweapp/export_files.dart';

class DatabaseHelper extends GetxController {
  static DatabaseHelper instance = Get.find();
  // String userId = auth.currentUser!.uid;
  static String chatRoom = "chatRoom/";
  static String affiliateMember = "affiliateMember/";
  static String affiliates = "affiliates/";
  static String business = "business/";
  static String members = "members/";
  static String paymentMethods = "paymentMethods/";
  static String transactions = "transactions/";
  // static String users = "contacts/";
  Tables tables = Tables();

  @override
  void onInit() {

    super.onInit();
  }

  String userTransaction() {
    return "${users()}/${userId()}/transactions";
  }

  String recentChats() {
    return "${users()}/${userId()}/recentChats";
  }

  String user() {
    return "${users()}/${userId()}";
  }
  String users() {
    return "users";
  }


  String addToStoreOrders() {
    return "orders";
  }
  String getUserStoreOrders() {
    return "${users()}/${userId()}/orders";
  }
  String userId() {
    return auth.currentUser!.uid;
  }
  String currencyExchangeTransfers() {
    return "currencyExchangeTransfers";
  }
  String contractExchange() {
    return "contractExchange";
  }

  String instantCashOutCharges(){
    return "instantCashOutCharges";
  }
  String contractDisputePath(){
    return "contractDisputes";
  }
  String contracts(){
    return "contracts";
  }
  String paymentMethodPath(){
    return "paymentMethod/${userId()}";
  }
}

class Tables{
  String affiliateMembers = "affiliateMembers";
  String affiliates = "affiliates";
  String business = "business";
  String chatRoom = "chatRoom";
  String users = "contacts";
  String contractsExchange = "contractsExchange";
  String contracts = "contracts";
  String currencyExchangeTransfer = "currencyExchangeTransfer";
  String instantCashOutCharges = "instantCashOutCharges";
  String marketPlace = "marketPlace";
  String userOrders = "userOrders";
  String moweServiceCharges = "moweServiceCharges";
  String paymentMethods = "paymentMethods";
  String transactions = "transactions";
  SubTables subTables = SubTables();
}
class SubTables{
  String categories = "categories";
  String transactions = "transactions";
  String chats = "chats";
  String account = "account";
  String card = "card";
  String recentChats = "recentChats";
  String businesses = "businesses";
  String calls = "calls";
  String callerCandidates = "callerCandidates";
  String calleeCandidates = "calleeCandidates";

}

class ChatRoomHelper {
  static String chatRoom = "chatRoom/";
  String referenceId = "";

  String chats() {
    return "$chatRoom/$referenceId/chats";
  }
  String transactions() {
    return "$chatRoom/$referenceId/transactions";
  }
}
