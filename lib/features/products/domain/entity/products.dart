import 'package:equatable/equatable.dart';

class ProductsEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final double rating;
  final List<ReviewEntity> reviews;
  final List<String> images;

  const ProductsEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.rating,
    this.reviews = const [],
    required this.images,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    thumbnail,
    reviews,
    rating,
    images,
  ];
}

class ReviewEntity extends Equatable {
  final int rating;
  final String comment;
  final String reviewerName;

  const ReviewEntity({
    required this.rating,
    required this.comment,
    required this.reviewerName,
  });

  @override
  List<Object?> get props => [rating, comment, reviewerName];
}
