import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/features/products/domain/entity/products.dart';
import 'package:flutter_application_2/features/products/domain/repository/product_repository.dart';

class GetProductsByCategoryUseCase {
  ProductRepository productRepository;
  GetProductsByCategoryUseCase(this.productRepository);
  Future<Either<Failures, List<ProductsEntity>>> call(
    ProductsByCategoryParams parms,
  ) async {
    return productRepository.getProductsByCategory(
      categoryName: parms.categoryName,
      limit: parms.limit,
      skip: parms.skip,
    );
  }
}

class ProductsByCategoryParams extends Equatable {
  final int limit;
  final int skip;
  final String categoryName;

  const ProductsByCategoryParams({
    required this.limit,
    required this.skip,
    required this.categoryName,
  });

  @override
  List<Object?> get props => [limit, skip];
}
