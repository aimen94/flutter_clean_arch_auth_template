import 'package:flutter_application_2/features/products/data/models/review_entity.dart';
import 'package:flutter_application_2/features/products/domin/entity/products.dart';

class ProductsModel extends ProductsEntity {
  ProductsModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.thumbnail,
    super.reviews = const [],
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'],
      reviews: (json['reviews'] as List)
          .map((reviewJson) => ReviewModel.fromJson(reviewJson))
          .toList(),
    );
  }
}
