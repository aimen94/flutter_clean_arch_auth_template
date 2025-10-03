import 'package:flutter_application_2/features/products/domin/entity/products.dart';

class ReviewModel extends ReviewsEntity {
  ReviewModel({
    required super.rating,
    required super.comment,
    required super.reviewName,
  });
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: json['rating'],
      comment: json['comment'],
      reviewName: json['reviewName'],
    );
  }
}
