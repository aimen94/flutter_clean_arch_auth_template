import 'package:equatable/equatable.dart';
import 'package:flutter_application_2/features/products/domain/entity/products.dart';

enum FeaturedProductsStatus { initial, loading, success, failure }

class FeaturedProductsState extends Equatable {
  final FeaturedProductsStatus status;
  final List<ProductsEntity> products;
  final String? errorMessage;

  const FeaturedProductsState({
    this.status = FeaturedProductsStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  FeaturedProductsState copyWith({
    FeaturedProductsStatus? status,
    List<ProductsEntity>? products,
    String? errorMessage,
  }) {
    return FeaturedProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage];
}
