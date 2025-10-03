import 'package:flutter_application_2/features/products/domin/usecase/get_product_by_id_use_case.dart';

import 'package:flutter_application_2/features/products/presentions/cubit/product_detail/products_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailCubit extends Cubit<ProductsDetailState> {
  final GetProductByIdUseCase getProductByIdUseCase;

  ProductDetailCubit({required this.getProductByIdUseCase})
    : super(ProductsDetailState());

  Future<void> fetchProductByID(int productId) async {
    emit(ProductsDetailState(isLoading: true));

    final result = await getProductByIdUseCase.call(productId);

    result.fold(
      (failure) => emit(
        ProductsDetailState(isLoading: false, errorMessage: failure.message),
      ),
      (product) =>
          emit(ProductsDetailState(isLoading: false, product: product)),
    );
  }
}

// import 'package:flutter_application_2/features/products/domin/usecase/get_product_by_id_use_case.dart';
// import 'package:flutter_application_2/features/products/presentions/cubit/product_detail/products_detail_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ProductDetailCubit extends Cubit<ProductsDetailState> {
//   final GetProductByIdUseCase getProductByIdUseCase;

//   ProductDetailCubit({required this.getProductByIdUseCase})
//     : super(ProductsDetailState());

//   Future<void> fetchProductByID(int productId) async {
//     emit(ProductsDetailState(isLoading: true));

//     final result = await getProductByIdUseCase.call(productId);

//     result.fold(
//       (failure) => emit(
//         ProductsDetailState(isLoading: false, errorMessage: failure.message),
//       ),
//       (product) =>
//           emit(ProductsDetailState(isLoading: false, product: product)),
//     );
//   }
// }
