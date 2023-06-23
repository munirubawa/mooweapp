// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:enum_to_string/enum_to_string.dart';
// import 'package:mooweapp/classes/carInformation.dart';
// import 'package:mooweapp/enums.dart';
//
// class Driver {
//   String? firstName;
//   String? lastName;
//   String? phone;
//   String? token;
//   int? votes = 0;
//   int? trips = 0;
//   double? rating = 0;
//   CarInformation? carInformation;
//
//   String? currencyCode;
//   String? currencySign;
//   String? transactionPath;
//   RideRequestStatus? requestStatus;
//   RideType? rideType;
//   String? newRide;
//   DocumentReference? reference;
//   late double? earnings;
//
// //<editor-fold desc="Data Methods">
//
//   Driver({
//     this.firstName,
//     this.lastName,
//     this.phone,
//     this.token,
//     this.votes,
//     this.trips,
//     this.rating,
//     this.carInformation,
//     this.currencyCode,
//     this.currencySign,
//     this.transactionPath,
//     this.requestStatus,
//     this.newRide,
//     this.reference,
//     this.rideType,
//     this.earnings = 0,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'firstName': firstName,
//       'lastName': lastName,
//       'phone': phone,
//       'token': token,
//       'votes': votes,
//       'trips': trips,
//       'rating': rating,
//       'carInformation': carInformation!.toMap(),
//       'currencyCode': currencyCode,
//       'currencySign': currencySign,
//       'transactionPath': transactionPath,
//       'requestStatus': EnumToString.convertToString(requestStatus),
//       'rideType': EnumToString.convertToString(rideType),
//       'newRide': newRide,
//       'earnings': earnings,
//     };
//   }
//
//
//   factory Driver.fromSnap(DocumentSnapshot snapshot) {
//     return Driver(
//       reference:  snapshot.reference,
//       firstName:  snapshot.get("firstName"),
//       lastName:  snapshot.get("lastName"),
//       phone:  snapshot.get("phone"),
//       token:  snapshot.get("token"),
//       votes:  snapshot.get("votes"),
//       trips:  snapshot.get("trips"),
//       rating:  snapshot.get("rating"),
//       carInformation:  CarInformation.fromMap(snapshot.get("carInformation")),
//       currencyCode:  snapshot.get("currencyCode"),
//       currencySign:  snapshot.get("currencySign"),
//       transactionPath:  snapshot.get("transactionPath"),
//       requestStatus: EnumToString.fromString(RideRequestStatus.values, snapshot.get("requestStatus")) ,
//       rideType: EnumToString.fromString(RideType.values, snapshot.get("rideType")) ,
//       newRide:  snapshot.get("newRide"),
//       earnings:  double.parse(snapshot.get("earnings").toString()),
//     );
//   }
//
// //</editor-fold>
//
// }