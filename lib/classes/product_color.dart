class ProductColor {
  String? color;
  int? quantity;

//<editor-fold desc="Data Methods">

  ProductColor({
    this.color,
    this.quantity,
  });


  Map<String, dynamic> toMap() {
    return {
      'color': color,
      'quantity': quantity,
    };
  }

  factory ProductColor.fromMap(Map<String, dynamic> map) {
    return ProductColor(
      color: map['color'] as String,
      quantity: map['quantity'] as int,
    );
  }

//</editor-fold>
}