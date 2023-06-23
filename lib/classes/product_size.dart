class ProductSize {
  String? size;
  int? quantity;

//<editor-fold desc="Data Methods">

  ProductSize({
    this.size,
    this.quantity,
  });



  Map<String, dynamic> toMap() {
    return {
      'size': size,
      'quantity': quantity,
    };
  }

  factory ProductSize.fromMap(Map<String, dynamic> map) {
    return ProductSize(
      size: map['size'] as String,
      quantity: map['quantity'] as int,
    );
  }

//</editor-fold>
}