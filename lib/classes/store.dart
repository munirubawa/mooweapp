

import 'package:mooweapp/classes/Product.dart';

class Store {
  String? storeName, categories, phone, currency, country, locality;
  List<Product>? products;

//<editor-fold desc="Data Methods">

  Store({
    this.storeName,
    this.categories,
    this.phone,
    this.currency,
    this.country,
    this.locality,
    this.products,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Store &&
          runtimeType == other.runtimeType &&
          storeName == other.storeName &&
          categories == other.categories &&
          phone == other.phone &&
          currency == other.currency &&
          country == other.country &&
          locality == other.locality &&
          products == other.products);

  @override
  int get hashCode =>
      storeName.hashCode ^
      categories.hashCode ^
      phone.hashCode ^
      currency.hashCode ^
      country.hashCode ^
      locality.hashCode ^
      products.hashCode;

  @override
  String toString() {
    return 'Store{' ' storeName: $storeName,' ' categories: $categories,' ' phone: $phone,' ' currency: $currency,' ' country: $country,' ' locality: $locality,' ' products: $products,' '}';
  }

  Store copyWith({
    String? storeName,
    String? categories,
    String? phone,
    String? currency,
    String? country,
    String? locality,
    List<Product>? products,
  }) {
    return Store(
      storeName: storeName ?? this.storeName,
      categories: categories ?? this.categories,
      phone: phone ?? this.phone,
      currency: currency ?? this.currency,
      country: country ?? this.country,
      locality: locality ?? this.locality,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storeName': storeName,
      'categories': categories,
      'phone': phone,
      'currency': currency,
      'country': country,
      'locality': locality,
      'products': products!.map((e) => e.toMap()),
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      storeName: map['storeName'] as String,
      categories: map['categories'] as String,
      phone: map['phone'] as String,
      currency: map['currency'] as String,
      country: map['country'] as String,
      locality: map['locality'] as String,
      products: map['products'].map((e) =>Product.fromMap(e)) as List<Product>,
    );
  }

//</editor-fold>
}