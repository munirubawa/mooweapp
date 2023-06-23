
// class DriverService {
//   String collection = 'drivers';
//
//   Stream<List<DriverModel>> getDrivers() {
//     return FirebaseFirestore.instance.collection(collection).snapshots().map((event) =>
//         event.docs.map((e) => DriverModel.fromSnapshot(e)).toList());
//   }
//
//   Future<DriverModel> getDriverById(String id) =>
//       FirebaseFirestore.instance.collection(collection).doc(id).get().then((doc) {
//         return DriverModel.fromSnapshot(doc);
//       });
//
//   Stream<QuerySnapshot> driverStream() {
//     CollectionReference reference = FirebaseFirestore.instance.collection(collection);
//     return reference.snapshots();
//   }
// }
