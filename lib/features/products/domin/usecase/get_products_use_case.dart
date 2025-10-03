import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/features/products/domin/entity/products.dart';
import 'package:flutter_application_2/features/products/domin/repository/product_repository.dart';

class GetProductsUseCase {
  ProductRepository productRepository;
  GetProductsUseCase(this.productRepository);
  Future<Either<Failures, List<ProductsEntity>>> call(ProductsParams params) {
    return productRepository.getProducts(
      limit: params.limit,
      skip: params.skip,
    );
  }
}

class ProductsParams extends Equatable {
  final int limit;
  final int skip;

  const ProductsParams({required this.limit, required this.skip});

  @override
  List<Object?> get props => [limit, skip];
}
