import 'package:dartz/dartz.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/features/products/domin/entity/products.dart';

abstract class ProductRepository {
  Future<Either<Failures, List<ProductsEntity>>> getProducts({
    int limit = 20,
    int skip = 0,
  });
  Future<Either<Failures, ProductsEntity>> getProductById(int id);
  Future<Either<Failures, List<ProductsEntity>>> getProductsByCategory(
    String categoryName,
  );
  Future<Either<Failures, List<String>>> getAllCategories();
  Future<Either<Failures, List<ProductsEntity>>> searchProducts({
    required String query,
    int limt = 20,
    int skip = 0,
  });
}
