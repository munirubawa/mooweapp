import 'package:flutter/material.dart';

class Product {
   String? image, title, description;
   double? price;
   int? size, id;
   Color? color;
  Product({
    this.id,
    this.image,
    this.title,
    this.price,
    this.description,
    this.size,
    this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'title': title,
      'description': description,
      'price': price,
      'size': size,
      'id': id,
      'color': color,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      image: map['image'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      size: map['size'] as int,
      id: map['id'] as int,
      color: map['color'] as Color,
    );
  }
}
List<Color> productColors = [
  const Color(0xFF3D82AE),
  const Color(0xFFD3A984),
  const Color(0xFF989493),
  const Color(0xFFE6B398),
  const Color(0xFFFB7883),
  const Color(0xFFAEAEAE)
];
List<Product> products = [
  Product(
      id: 1,
      title: "Office Code",
      price: 234,
      size: 12,
      description: dummyText,
      image: "assets/images/bag_1.png",
      color: productColors[0]),
  Product(
      id: 2,
      title: "Belt Bag",
      price: 234,
      size: 8,
      description: dummyText,
      image: "assets/images/bag_2.png",
      color: productColors[1]),
  Product(
      id: 3,
      title: "Hang Top",
      price: 234,
      size: 10,
      description: dummyText,
      image: "assets/images/bag_3.png",
      color: productColors[2]),
  Product(
      id: 4,
      title: "Old Fashion",
      price: 234,
      size: 11,
      description: dummyText,
      image: "assets/images/bag_4.png",
      color: productColors[3]),
  Product(
      id: 5,
      title: "Office Code",
      price: 234,
      size: 12,
      description: dummyText,
      image: "assets/images/bag_5.png",
      color: productColors[4]),
  Product(
    id: 6,
    title: "Office Code",
    price: 234,
    size: 12,
    description: dummyText,
    image: "assets/images/bag_6.png",
    color: productColors[5],
  ),
];

String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";
