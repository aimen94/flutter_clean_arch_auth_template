import 'package:equatable/equatable.dart';
import 'package:flutter_application_2/features/products/domain/entity/products.dart';

enum SearchStatus { initial, loading, success, failure, loadingMore }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<ProductsEntity> searchResults;
  final bool hasReachedMax;
  final String? errorMessage;
  final int page;
  final String currentQuery;

  const SearchState({
    this.status = SearchStatus.initial,
    this.searchResults = const [],
    this.hasReachedMax = false,
    this.errorMessage,
    this.page = 0,
    this.currentQuery = '',
  });
  SearchState copyWith({
    SearchStatus? status,
    List<ProductsEntity>? searchResults,
    bool? hasReachedMax,
    String? errorMessage,
    int? page,
    String? currentQuery,
  }) {
    return SearchState(
      status: status ?? this.status,
      searchResults: searchResults ?? this.searchResults,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      currentQuery: currentQuery ?? this.currentQuery,
    );
  }

  @override
  List<Object?> get props => [
    status,
    searchResults,
    hasReachedMax,
    errorMessage,
    page,
    currentQuery,
  ];
}
