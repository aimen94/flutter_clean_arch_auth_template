import 'package:equatable/equatable.dart';

class ProductsEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final double price;
  final thumbnail;
  final List<ReviewsEntity> reviews;
  ProductsEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    this.reviews = const [],
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    thumbnail,
    reviews,
  ];
}

class ReviewsEntity extends Equatable {
  final double rating;
  final String comment;

  final String reviewName;
  ReviewsEntity({
    required this.rating,
    required this.comment,
    required this.reviewName,
  });

  @override
  List<Object?> get props => [rating, comment, reviewName];
}
