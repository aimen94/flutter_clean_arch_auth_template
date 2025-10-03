import 'package:flutter_application_2/features/products/domain/usecase/get_search_products_use_case.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/searche/searche_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _searchLimit = 20;

class SearchCubit extends Cubit<SearchState> {
  GetSearchProductsUseCase getSearchProductsUseCase;
  SearchCubit({required this.getSearchProductsUseCase}) : super(SearchState());

  Future<void> searcheProducts(String query) async {
    if (query == state.currentQuery && state.status != SearchStatus.initial)
      return;
    emit(
      state.copyWith(
        status: SearchStatus.initial,
        searchResults: [],
        hasReachedMax: false,
        page: 0,
        currentQuery: query,
      ),
    );
    await _fetchData(query: query, pageTofetch: state.page);
  }

  Future<void> featchMoreSearchProducts() async {
    if (state.hasReachedMax || state.status == SearchStatus.loadingMore) return;
    {
      emit(state.copyWith(status: SearchStatus.loadingMore));
      await _fetchData(query: state.currentQuery, pageTofetch: state.page);
    }
  }

  Future<void> _fetchData({
    required String query,
    required int pageTofetch,
  }) async {
    if (query.isEmpty) {
      emit(state.copyWith(status: SearchStatus.initial, searchResults: []));
      return;
    }
    final parms = SearchParams(
      query: query,
      limit: _searchLimit,
      skip: pageTofetch * _searchLimit,
    );
    final results = await getSearchProductsUseCase(parms);
    return results.fold(
      (failure) => emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (newProduct) {
        final isInitialFetch = pageTofetch == 0;
        emit(
          state.copyWith(
            status: SearchStatus.success,
            searchResults: isInitialFetch
                ? newProduct
                : (List.of(state.searchResults)..addAll(newProduct)),
            page: pageTofetch + 1,
            hasReachedMax:
                newProduct.isEmpty || newProduct.length < _searchLimit,
          ),
        );
      },
    );
  }

  // Future<void> fetchSearchProducts(
  //   String query, {
  //   bool isLoadMore = false,
  // }) async {
  //   if (state.hasReachedMax && isLoadMore) return;
  //   try {
  //     if (isLoadMore) {
  //       emit(state.copyWith(status: SearchStatus.loadingMore));
  //     } else {
  //       emit(
  //         state.copyWith(
  //           status: SearchStatus.loading,
  //           searchResults: [],
  //           hasReachedMax: false,
  //           page: 0,
  //           currentQuery: query,
  //         ),
  //       );
  //     }
  //     final nextPage = isLoadMore ? state.page + 1 : 0;
  //     final results = await getSearchProductsUseCase.call(
  //       SearchParams(query: query, limit: 20, skip: nextPage * 20),
  //     );
  //     results.fold(
  //       (failure) {
  //         emit(
  //           state.copyWith(
  //             status: SearchStatus.failure,
  //             errorMessage: failure.message,
  //           ),
  //         );
  //       },
  //       (products) {
  //         final hasReachedMax = products.isEmpty;
  //         final updatedResults = isLoadMore
  //             ? (List.of(state.searchResults)..addAll(products))
  //             : products;
  //         emit(
  //           state.copyWith(
  //             status: SearchStatus.success,
  //             searchResults: updatedResults,
  //             hasReachedMax: hasReachedMax,
  //             page: nextPage,
  //             currentQuery: query,
  //           ),
  //         );
  //       },
  //     );
  //   } catch (e) {
  //     emit(
  //       state.copyWith(
  //         status: SearchStatus.failure,
  //         errorMessage: e.toString(),
  //       ),
  //     );
  //   }
  //}
  // future<void> fetchSearchProducts(String query, {bool isLoadMore = false}) async {
  //   if (state.hasReachedMax && isLoadMore) return;

  //   try {
  //     if (isLoadMore) {
  //       emit(state.copyWith(status: SearchStatus.loadingMore));
  //     } else {
  //       emit(state.copyWith(
  //         status: SearchStatus.loading,
  //         searchResults: [],
  //         hasReachedMax: false,
  //         page: 0,
  //         currentQuery: query,
  //       ));
  //     }

  //     final nextPage = isLoadMore ? state.page + 1 : 0;
  //     final results = await getSearchProductsUseCase.call(
  //       GetSearchProductsParams(query: query, page: nextPage),
  //     );

  //     results.fold(
  //       (failure) {
  //         emit(state.copyWith(
  //           status: SearchStatus.failure,
  //           errorMessage: failure.message,
  //         ));
  //       },
  //       (products) {
  //         final hasReachedMax = products.isEmpty;
  //         final updatedResults = isLoadMore
  //             ? List.of(state.searchResults)..addAll(products)
  //             : products;

  //         emit(state.copyWith(
  //           status: SearchStatus.success,
  //           searchResults: updatedResults,
  //           hasReachedMax: hasReachedMax,
  //           page: nextPage,
  //           currentQuery: query,
  //         ));
  //       },
  //     );
  //   } catch (e) {
  //     emit(state.copyWith(
  //       status: SearchStatus.failure,
  //       errorMessage: e.toString(),
  //     ));
  //   }
  // }
}
