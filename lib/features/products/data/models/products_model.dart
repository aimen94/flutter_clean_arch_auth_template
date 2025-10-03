import 'package:flutter_application_2/features/products/data/models/review_entity.dart';
import 'package:flutter_application_2/features/products/domain/entity/products.dart';

class ProductModel extends ProductsEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.thumbnail,
    required super.reviews,
    required super.rating,
    required super.images,
  });

  // ✨✨ منطق التحويل المعقد موجود هنا في الـ Model ✨✨
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // استخراج قائمة المراجعات وتحويلها
    var reviewsList = <ReviewModel>[];
    if (json['reviews'] != null) {
      reviewsList = (json['reviews'] as List)
          .map((reviewJson) => ReviewModel.fromJson(reviewJson))
          .toList();
    }
    var imagesList = <String>[];
    if (json['images'] != null) {
      // التأكد من أن كل عنصر هو String
      imagesList = List<String>.from(json['images']);
    }

    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      // التحويل الآمن للرقم
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      thumbnail: json['thumbnail'],
      reviews: reviewsList.map((r) => r as ReviewEntity).toList(),
      images: imagesList,
    );
  }
}
