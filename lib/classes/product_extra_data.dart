import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:mooweapp/enums.dart';

class ProductExtraData {
  ExtraDataType? extraDataType;
  Map<String, dynamic>? data;

//<editor-fold desc="Data Methods">

  ProductExtraData({
    this.extraDataType,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'extraDataType': EnumToString.convertToString(extraDataType),
      'data': data,
    };
  }

  factory ProductExtraData.fromMap(Map<String, dynamic> map) {
    return ProductExtraData(
      extraDataType:  EnumToString.fromString(ExtraDataType.values, map['extraDataType']),
      data: map['data'] as Map<String, dynamic>,
    );
  }

  factory ProductExtraData.fromSnap(DocumentSnapshot snapshot) {
    return ProductExtraData(
      extraDataType:  EnumToString.fromString(ExtraDataType.values, snapshot.get('extraDataType')),
      data: snapshot.get('data'),
    );
  }

//</editor-fold>
}
