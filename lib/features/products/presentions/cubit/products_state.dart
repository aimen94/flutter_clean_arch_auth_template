import 'package:equatable/equatable.dart';
import 'package:flutter_application_2/features/products/domin/entity/products.dart';

enum ProductStatus { initial, loading, success, failure, loadingMore }

class ProductsState extends Equatable {
  final ProductStatus status;
  final List<String> categories;
  final List<ProductsEntity> products;
  final bool hasReachedMax;
  final String? errorMessage;
  final int page;
  final ProductsEntity? selectedProduct;
  const ProductsState({
    this.status = ProductStatus.initial,
    this.categories = const [],
    this.products = const <ProductsEntity>[],
    this.hasReachedMax = false,
    this.errorMessage,
    this.page = 0,
    this.selectedProduct,
  });
  ProductsState copyWith({
    ProductStatus? status,
    List<String>? categories,
    List<ProductsEntity>? products,
    bool? hasReachedMax,
    String? errorMessage,
    int? page,
    ProductsEntity? selectedProduct,
  }) {
    return ProductsState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      selectedProduct: selectedProduct ?? this.selectedProduct,
    );
  }

  @override
  List<Object?> get props => [
    status,
    categories,
    products,
    hasReachedMax,
    errorMessage,
    page,
    selectedProduct,
  ];
}
