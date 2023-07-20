// import 'package:mooweapp/export_files.dart';
//
// class AddressController extends GetxController {
//   static AddressController instance = Get.find();
//   late GooglePlace googlePlace;
//   var predictions = RxList<AutocompletePrediction>([]);
//   final geo = GeoFlutterFire();
//   DetailsResult? detailsResult;
//   Business business = Business();
//   String pointData = "";
//   // List<Placemark>? addressMarker;
//   RxString address = RxString("");
//   RxString city = RxString("");
//   RxString state = RxString("");
//   RxString zip = RxString("");
//   AutocompletePrediction? selectedAddress;
//   RxBool isAddressSelected = RxBool(false);
//   @override
//   void onInit() {
//     super.onInit();
//     ever(apiController.apiKeyModel, (callback){
//       if(apiController.apiKeyModel.value.success!) {
//         googlePlace = GooglePlace(apiController.apiKeyModel.value.googleMapApiKey!);
//       }
//     });
//
//   }
//
//   showAddressDetails() {
//     if(address.isNotEmpty && city.isNotEmpty && state.isNotEmpty && zip.isNotEmpty) {
//       isAddressSelected.value = true;
//     }
//   }
//
//   void autoCompleteSearch(String value) async {
//     if (kDebugMode) {
//       print("autoCompleteSearch");
//     }
//     if (value.isNotEmpty) {
//       if (kDebugMode) {
//         print(value);
//       }
//       var result = await googlePlace.autocomplete.get(value);
//       if (kDebugMode) {
//         print("result!.predictions!.length");
//         print(result!.predictions!.length);
//       }
//
//       if (result != null && result.predictions != null && result.status == "OK") {
//         predictions.value = result.predictions!;
//       }
//     }
//   }
// }