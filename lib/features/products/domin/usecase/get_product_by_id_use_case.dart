import 'package:dartz/dartz.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/features/products/domin/entity/products.dart';
import 'package:flutter_application_2/features/products/domin/repository/product_repository.dart';

class GetProductByIdUseCase {
  ProductRepository productRepository;
  GetProductByIdUseCase(this.productRepository);
  Future<Either<Failures, ProductsEntity>> call(int id) {
    return productRepository.getProductById(id);
  }
}
