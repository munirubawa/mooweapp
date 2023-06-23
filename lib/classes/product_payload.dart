import 'package:cloud_firestore/cloud_firestore.dart';

class ProductPayload{
  List<dynamic>? productExtraData;

  String? id;
  List<dynamic>? images;
  String? name;
  String? description;
  String? brand;
  double? price;
  String? storeId;
  String? category;
  String? currencySign;
  String? currencyCode;
  String buyerCurrencySign = "";
  String buyerCurrencyCode = "";
  double buyerPrice = 0.0;

  int? quantity;
  DocumentReference? reference;


  factory ProductPayload.fromSnap(DocumentSnapshot snapShot) {
    return ProductPayload(
      reference: snapShot.reference,
      productExtraData:  snapShot['productExtraData'],
      currencySign:  snapShot['currencySign'],
      currencyCode:  snapShot['currencyCode'],
      id: snapShot.get("id") ,
      images: snapShot.get("images") ,
      name: snapShot.get("name") ,
      description: snapShot.get("description") ,
      brand: snapShot.get("brand"),
      price: snapShot.get("price").toDouble(),
      storeId: snapShot.get("storeId"),
      category: snapShot.get("category"),
      quantity: snapShot.get("quantity"),
      buyerCurrencySign: snapShot.get("buyerCurrencySign"),
      buyerCurrencyCode: snapShot.get("buyerCurrencyCode"),
      buyerPrice: snapShot.get("buyerPrice"),
    );
  }

//<editor-fold desc="Data Methods">

  ProductPayload({
    this.productExtraData,
    this.id,
    this.images,
    this.name,
    this.description,
    this.brand,
    this.price,
    this.storeId,
    this.category,
    this.currencySign,
    this.currencyCode,
    this.buyerCurrencySign = "",
    this.buyerCurrencyCode = "",
    this.buyerPrice = 0,
    this.quantity,
    this.reference,
  });

  Map<String, dynamic> toMap() {
    return {
      'productExtraData': productExtraData,
      'id': id,
      'images': images,
      'name': name,
      'description': description,
      'brand': brand,
      'price': price,
      'storeId': storeId,
      'category': category,
      'currencySign': currencySign,
      'currencyCode': currencyCode,
      'buyerCurrencySign': buyerCurrencySign,
      'buyerCurrencyCode': buyerCurrencyCode,
      'buyerPrice': buyerPrice,
      'quantity': quantity,
    };
  }

  factory ProductPayload.fromMap(Map<String, dynamic> map) {
    return ProductPayload(
      productExtraData: map['productExtraData'] as List<dynamic>,
      id: map['id'] as String,
      images: map['images'] as List<dynamic>,
      name: map['name'] as String,
      description: map['description'] as String,
      brand: map['brand'] as String,
      price: map['price'] as double,
      storeId: map['storeId'] as String,
      category: map['category'] as String,
      currencySign: map['currencySign'] as String,
      currencyCode: map['currencyCode'],
      buyerCurrencySign: map.containsKey("buyerCurrencySign")? map['buyerCurrencySign']: "",
      buyerCurrencyCode: map.containsKey("buyerCurrencyCode")? map['buyerCurrencyCode']: "",
      buyerPrice: map.containsKey("buyerPrice")? map['buyerPrice']: 0.0,
      quantity: map['quantity'] as int,
    );
  }

  ProductPayload copyWith({
    List<dynamic>? productExtraData,
    String? id,
    List<dynamic>? images,
    String? name,
    String? description,
    String? brand,
    double? price,
    String? storeId,
    String? category,
    String? currencySign,
    String? currencyCode,
    String? buyerCurrencySign,
    String? buyerCurrencyCode,
    double? buyerPrice,
    int? quantity,
    DocumentReference? reference,
  }) {
    return ProductPayload(
      productExtraData: productExtraData ?? this.productExtraData,
      id: id ?? this.id,
      images: images ?? this.images,
      name: name ?? this.name,
      description: description ?? this.description,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      storeId: storeId ?? this.storeId,
      category: category ?? this.category,
      currencySign: currencySign ?? this.currencySign,
      currencyCode: currencyCode ?? this.currencyCode,
      buyerCurrencySign: buyerCurrencySign ?? this.buyerCurrencySign,
      buyerCurrencyCode: buyerCurrencyCode ?? this.buyerCurrencyCode,
      buyerPrice: buyerPrice ?? this.buyerPrice,
      quantity: quantity ?? this.quantity,
      reference: reference ?? this.reference,
    );
  }
//</editor-fold>
}