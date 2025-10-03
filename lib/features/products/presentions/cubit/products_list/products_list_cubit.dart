import 'package:flutter_application_2/features/products/domain/usecase/get_product_by_id_use_case.dart';
import 'package:flutter_application_2/features/products/domain/usecase/get_products_by_category_use_case.dart';
import 'package:flutter_application_2/features/products/domain/usecase/get_products_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'products_list_state.dart';

const _productLimit = 20; // تعريف ثابت لتسهيل التعديل

class ProductsListCubit extends Cubit<ProductsListState> {
  final GetProductsUseCase _getProductsUseCase;
  final GetProductsByCategoryUseCase productsByCategoryUseCase;
  ProductsListCubit({
    required GetProductsUseCase getProductsUseCase,
    required this.productsByCategoryUseCase,
  }) : _getProductsUseCase = getProductsUseCase, // استخدام private convention
       super(ProductsListState());

  Future<void> fetchInitialProducts() async {
    emit(
      state.copyWith(
        status: ProductListStatus.loading,
        products: [],
        page: 0,
        hasReachedMax: false,
        selectedCategory: null,
        forceCategoryUpdate: true,
      ),
    );

    final params = const ProductsParams(limit: _productLimit, skip: 0);
    final result = await _getProductsUseCase(params);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (products) => emit(
        state.copyWith(
          status: ProductListStatus.success,
          products: products,
          page: 1,
          hasReachedMax: products.length < _productLimit,
        ),
      ),
    );
  }

  Future<void> fetchMoreProducts() async {
    if (state.hasReachedMax ||
        state.status == ProductListStatus.loadingMore ||
        state.selectedCategory != null)
      return;

    emit(state.copyWith(status: ProductListStatus.loadingMore));

    final params = ProductsParams(
      limit: _productLimit,
      skip: state.page * _productLimit,
    );
    final result = await _getProductsUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (newProducts) {
        if (newProducts.isEmpty) {
          emit(
            state.copyWith(
              hasReachedMax: true,
              status: ProductListStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: ProductListStatus.success,
              products: List.of(state.products)..addAll(newProducts),
              page: state.page + 1,
              selectedCategory: null,
              hasReachedMax: newProducts.length < _productLimit,
            ),
          );
        }
      },
    );
  }

  Future<void> fetchInitialProductsByCategory(String category) async {
    emit(
      state.copyWith(
        status: ProductListStatus.loading,
        products: [],
        page: 0,
        hasReachedMax: false,
        selectedCategory: category,
      ),
    );

    final params = ProductsByCategoryParams(
      categoryName: category,
      limit: _productLimit,
      skip: 0,
    );
    final result = await productsByCategoryUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (products) => emit(
        state.copyWith(
          status: ProductListStatus.success,
          products: products,
          page: 1,
          hasReachedMax: products.length < _productLimit,
        ),
      ),
    );
  }

  Future<void> fetchMoreProductsByCategory(String category) async {
    if (state.hasReachedMax ||
        state.status == ProductListStatus.loadingMore ||
        state.selectedCategory != category)
      return;

    emit(state.copyWith(status: ProductListStatus.loadingMore));
    final params = ProductsByCategoryParams(
      categoryName: category,
      limit: _productLimit,
      skip: state.page * _productLimit,
    );
    //final result = await productsByCategoryUseCase.call(params);
    final result = await productsByCategoryUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (newProducts) {
        if (newProducts.isEmpty) {
          emit(
            state.copyWith(
              hasReachedMax: true,
              status: ProductListStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: ProductListStatus.success,
              products: List.of(state.products)..addAll(newProducts),
              page: state.page + 1,
              hasReachedMax: newProducts.length < _productLimit,
            ),
          );
        }
      },
    );
  }
}
