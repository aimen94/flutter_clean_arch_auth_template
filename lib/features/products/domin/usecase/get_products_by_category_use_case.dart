import 'package:dartz/dartz.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/features/products/domin/entity/products.dart';
import 'package:flutter_application_2/features/products/domin/repository/product_repository.dart';

class GetProductsByCategoryUseCase {
  ProductRepository productRepository;
  GetProductsByCategoryUseCase(this.productRepository);
  Future<Either<Failures, List<ProductsEntity>>> call(String categoryName) {
    return productRepository.getProductsByCategory(categoryName);
  }
}
