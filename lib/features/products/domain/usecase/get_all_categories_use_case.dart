import 'package:dartz/dartz.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/features/products/domain/repository/product_repository.dart';

class GetAllCategoriesUseCase {
  ProductRepository productRepository;
  GetAllCategoriesUseCase(this.productRepository);
  Future<Either<Failures, List<String>>> call() {
    return productRepository.getAllCategories();
  }
}
