import 'package:flutter_application_2/features/products/domain/usecase/get_all_categories_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetAllCategoriesUseCase getAllCategoriesUseCase;
  CategoriesCubit(this.getAllCategoriesUseCase)
    : super(const CategoriesState());

  Future<void> fetchCategories() async {
    // منع الطلبات المتكررة إذا كانت البيانات موجودة أو قيد التحميل
    if (state.status == CategoriesStatus.loading ||
        state.status == CategoriesStatus.success)
      return;

    emit(state.copyWith(status: CategoriesStatus.loading));

    final result = await getAllCategoriesUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CategoriesStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (categories) => emit(
        state.copyWith(
          status: CategoriesStatus.success,
          categories: categories,
        ),
      ),
    );
  }
}
