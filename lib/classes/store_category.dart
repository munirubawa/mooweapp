import 'package:mooweapp/export_files.dart';
class StoreCategory{
  String? category;
  DocumentReference? reference;
//<editor-fold desc="Data Methods">

  StoreCategory({
    this.category,
    this.reference,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
    };
  }

  factory StoreCategory.fromMap(Map<String, dynamic> map) {
    return StoreCategory(
      category: map['category'] as String,
    );
  }
  factory StoreCategory.fromSnap(DocumentSnapshot snapshot) {
    return StoreCategory(
      reference : snapshot.reference,
      category: snapshot.get("category"),
    );
  }

//</editor-fold>
}