import 'package:flutter/rendering.dart';
import 'package:flutter_application_2/features/products/domin/entity/products.dart';
import 'package:flutter_application_2/features/products/domin/usecase/get_all_categories_use_case.dart';
import 'package:flutter_application_2/features/products/domin/usecase/get_product_by_id_use_case.dart';
import 'package:flutter_application_2/features/products/domin/usecase/get_products_by_category_use_case.dart';
import 'package:flutter_application_2/features/products/domin/usecase/get_products_use_case.dart';
import 'package:flutter_application_2/features/products/domin/usecase/get_search_products_use_case.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase getProductsUseCase;
  final GetAllCategoriesUseCase getAllCategoriesUseCase;
  final GetProductByIdUseCase getProductByIdUseCase;
  final GetSearchProductsUseCase getSearchProductsUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;
  ProductsCubit({
    required this.getProductsUseCase,
    required this.getAllCategoriesUseCase,
    required this.getProductByIdUseCase,
    required this.getSearchProductsUseCase,
    required this.getProductsByCategoryUseCase,
  }) : super(const ProductsState());

  Future<void> fetchInitialProducts(int limit, int skip) async {
    if (state == ProductStatus.initial) {
      emit(state.copyWith(status: ProductStatus.loading));
      final params = ProductsParams(limit: limit, skip: skip);
      final result = await getProductsUseCase.call(params);
      result.fold(
        (faliure) => emit(
          state.copyWith(
            status: ProductStatus.failure,
            errorMessage: faliure.message,
          ),
        ),
        (products) => emit(
          state.copyWith(
            status: ProductStatus.success,
            products: products,
            page: state.page + 1,
            hasReachedMax: products.length < limit ? true : false,
          ),
        ),
      );
    }
  }

  Future<void> featchMoreProducts(int limit, int skip) async {
    emit(state.copyWith(status: ProductStatus.loadingMore));
    final params = ProductsParams(limit: limit, skip: skip);
    final result = await getProductsUseCase.call(params);
    result.fold(
      (faliure) => emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: faliure.message,
        ),
      ),
      (newProducts) {
        if (newProducts.isEmpty) {
          emit(
            state.copyWith(hasReachedMax: true, status: ProductStatus.success),
          );
        } else {
          emit(
            state.copyWith(
              status: ProductStatus.success,
              products: List.of(state.products)..addAll(newProducts),
              page: state.page + 1,
              // hasReachedMax: newProduct.length < limit ? true : false,
              hasReachedMax: newProducts.length < limit,
            ),
          );
        }
      },
    );
  }

  Future<void> featchProudecById(int id) async {
    emit(state.copyWith(status: ProductStatus.loading));
    final result = await getProductByIdUseCase.call(id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (product) => emit(
        state.copyWith(
          status: ProductStatus.success,
          //products: product as List<ProductsEntity>,
          products: List.of(state.products)..add(product),
          selectedProduct: product,
        ),
      ),
    );
  }

  Future<void> featchInitialProudectsByCategory(String category) async {
    emit(state.copyWith(status: ProductStatus.loading));
    final result = await getProductsByCategoryUseCase.call(category);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (products) => emit(
        state.copyWith(
          status: ProductStatus.success,
          products: products,
          hasReachedMax: true,
          page: state.page + 1,
        ),
      ),
    );
  }

  Future<void> fetchMoreProductsByCategory(String category) async {
    emit(state.copyWith(status: ProductStatus.loadingMore));
    final result = await getProductsByCategoryUseCase.call(category);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (NewProducts) {
        if (NewProducts.isEmpty) {
          emit(
            state.copyWith(hasReachedMax: true, status: ProductStatus.success),
          );
        } else {
          emit(
            state.copyWith(
              status: ProductStatus.success,
              products: List.of(state.products)..addAll(NewProducts),
              page: state.page + 1,
              hasReachedMax: NewProducts.length < 20,
            ),
          );
        }
      },
    );
  }

  Future<void> fetchAllCategories() async {
    emit(state.copyWith(status: ProductStatus.loading));
    final result = await getAllCategoriesUseCase.call();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (category) => emit(
        state.copyWith(
          status: ProductStatus.success,
          categories: category,
          hasReachedMax: true,
        ),
      ),
    );
  }

  Future<void> fetchSearchProducts(String query, int limit, int skip) async {
    emit(state.copyWith(status: ProductStatus.loading));
    final params = SearchParams(query: query, limit: limit, skip: skip);
    final result = await getSearchProductsUseCase.call(params);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (products) => emit(
        state.copyWith(
          status: ProductStatus.success,
          products: products,
          page: state.page + 1,
          hasReachedMax: products.length < limit ? true : false,
        ),
      ),
    );
  }
}
