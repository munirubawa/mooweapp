
//
// import 'package:mooweapp/classes/transactions.dart';
//
// class TransactionWithUserAddress{
//   MooweTransactions transactions;
//   // Placemark address;
//
// //<editor-fold desc="Data Methods">
//
//   TransactionWithUserAddress({
//     required this.transactions,
//   });
//
//
//   Map<String, dynamic> toMap() {
//     return {
//       'transactions': transactions.toMap(),
//       'address': address.toJson(),
//     };
//   }
//
//   factory TransactionWithUserAddress.fromMap(Map<String, dynamic> map) {
//     return TransactionWithUserAddress(
//       transactions:  MooweTransactions.fromJson(map['transactions']),
//       address: Placemark.fromMap(map['address']),
//     );
//   }
//
// //</editor-fold>
// }