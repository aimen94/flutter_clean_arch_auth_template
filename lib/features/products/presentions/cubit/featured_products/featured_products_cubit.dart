import 'package:flutter_application_2/features/products/domain/usecase/get_products_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'featured_products_state.dart';

class FeaturedProductsCubit extends Cubit<FeaturedProductsState> {
  final GetProductsUseCase _getProductsUseCase;

  FeaturedProductsCubit(this._getProductsUseCase)
    : super(const FeaturedProductsState());

  Future<void> fetchFeaturedProducts() async {
    if (state.status == FeaturedProductsStatus.loading ||
        state.status == FeaturedProductsStatus.success)
      return;

    emit(state.copyWith(status: FeaturedProductsStatus.loading));

    // جلب أول 10 منتجات كمنتجات مميزة
    final params = const ProductsParams(limit: 10, skip: 0);
    final result = await _getProductsUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FeaturedProductsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (products) => emit(
        state.copyWith(
          status: FeaturedProductsStatus.success,
          products: products,
        ),
      ),
    );
  }
}
