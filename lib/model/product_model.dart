import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? productBarcode;
  String? productName;
  String? productImage;
  Double? productPrice;

  ProductModel(
      {required this.productBarcode, required this.productName, required this.productImage, required this.productPrice});

 /* Map<String, dynamic> toJson() {
    return {
      'productBarcode': productBarcode,
      'productName': productName,
      'productImage': productImage,
      'productPrice': productPrice,
    };
  }
  static ProductModel fromJson(Map<String, dynamic> json) => ProductModel (
    productBarcode: json['productBarcode'],
    productName: json['productName'],
    productImage: json['productImage'],
    productPrice: json['productPrice'],
  );*/

  static ProductModel fromSnapshot(DocumentSnapshot snap) {
    ProductModel product = ProductModel(
      productBarcode: snap['productBarcode'],
      productName: snap['productName'],
      productImage: snap['productImage'],
      productPrice: snap['productPrice'],
    );
    return product;
  }
}