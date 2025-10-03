import 'package:equatable/equatable.dart';
import 'package:flutter_application_2/features/products/domain/entity/products.dart';

enum ProductListStatus { initial, loading, success, loadingMore, failure }

class ProductsListState extends Equatable {
  final ProductListStatus status;
  final List<ProductsEntity> products;
  final bool hasReachedMax;
  final String? errorMessage;
  final int page;
  final String? selectedCategory;

  const ProductsListState({
    this.status = ProductListStatus.initial,
    this.products = const <ProductsEntity>[],
    this.hasReachedMax = false,
    this.errorMessage,
    this.page = 0,
    this.selectedCategory,
  });
  ProductsListState copyWith({
    ProductListStatus? status,
    List<ProductsEntity>? products,
    bool? hasReachedMax,
    String? errorMessage,
    int? page,
    String? selectedCategory,
    bool forceCategoryUpdate = false,
  }) {
    return ProductsListState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      //selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCategory: forceCategoryUpdate
          ? selectedCategory
          : (selectedCategory ?? this.selectedCategory),
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    hasReachedMax,
    errorMessage,
    page,
    selectedCategory,
  ];
}
