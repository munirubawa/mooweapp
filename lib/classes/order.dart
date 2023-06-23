

import 'package:cloud_firestore/cloud_firestore.dart';

class StoreOrder{
    String order = "order";
    String buyerId = "buyerId";
    String dateTime = "dateTime";
  DocumentReference? reference;

  String shipToAddress = "shipToAddress";
}