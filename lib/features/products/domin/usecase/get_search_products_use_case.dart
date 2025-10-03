import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/features/products/domin/entity/products.dart';
import 'package:flutter_application_2/features/products/domin/repository/product_repository.dart';

class GetSearchProductsUseCase {
  ProductRepository productRepository;
  GetSearchProductsUseCase(this.productRepository);
  Future<Either<Failures, List<ProductsEntity>>> call(SearchParams params) {
    return productRepository.searchProducts(
      query: params.query,
      limt: params.limit,
      skip: params.skip,
    );
  }
}

class SearchParams extends Equatable {
  final String query;
  final int limit;
  final int skip;

  const SearchParams({
    required this.query,
    required this.limit,
    required this.skip,
  });

  @override
  List<Object?> get props => [query, limit, skip];
}
