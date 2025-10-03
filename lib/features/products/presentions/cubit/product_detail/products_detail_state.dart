import 'package:equatable/equatable.dart';
import 'package:flutter_application_2/features/products/domain/entity/products.dart';

class ProductsDetailState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final ProductsEntity? product;

  const ProductsDetailState({
    this.isLoading = false,
    this.errorMessage,
    this.product,
  });

  ProductsDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    ProductsEntity? product,
  }) {
    return ProductsDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      product: product ?? this.product,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, product];
}
