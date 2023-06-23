// import 'package:mooweapp/export_files.dart';
// class Address {
//   late String _placeFormattedAddress;
//   late String _placeName;
//   late String _placeId;
//   late Location _location;
//
//   set location(Location value) =>_location = value;
//
//   Location get location => _location; // late double _latitude;
//   // late double _longitude;
//   late String _shortName;
//
//   String get shortName => _shortName;
//
//   set shortName(String value) => _shortName = value;
//
//   set placeFormattedAddress(String value) => _placeFormattedAddress = value;
//
//   set placeId(String value) => _placeId = value;
//
//   set placeName(String value) => _placeName = value;
//
//   String get placeFormattedAddress => _placeFormattedAddress;
//
//   String get placeId => _placeId;
//
//   String get placeName => _placeName;
//
//   Map<String, dynamic> toMap() {
//     return {
//       '_placeFormattedAddress': _placeFormattedAddress,
//       '_placeName': _placeName,
//       '_placeId': _placeId,
//         "_location": _location.toJson(),
//       '_shortName': _shortName,
//     };
//   }
//
//   fromMap(Map<String, dynamic> map) {
//
//       placeFormattedAddress = map['_placeFormattedAddress'];
//       placeName = map['_placeName'];
//       placeId = map['_placeId'] ;
//       location = Location.fromMap(map['_location']);
//       shortName = map['_shortName'] ;
//
//   }
// }

AddressModel addressModel = AddressModel();
class AddressModel{
  String name = "name";
  String street = "street";
  String isoCountryCode = "isoCountryCode";
  String country = "country";
  String postalCode = "postalCode";
  String administrativeArea = "administrativeArea";
  String subAdministrativeArea = "subAdministrativeArea";
  String locality = "locality";
  String subLocality = "subLocality";
  String thoroughfare = "thoroughfare";
  String subThoroughfare = "subThoroughfare";
}