import 'package:dartz/dartz.dart';
import 'package:flutter_application_2/core/errors/exceptions.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/core/network/network_info.dart';
import 'package:flutter_application_2/features/products/data/datasources/product_remote_data_source.dart';
import 'package:flutter_application_2/features/products/domin/entity/products.dart';
import 'package:flutter_application_2/features/products/domin/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final NetworkInfo networkInfo;
  final ProductRemoteDataSource remoteDataSource;
  ProductRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });
  //helper Fucction
  Future<Either<Failures, T>> _hadelNetworkRequest<T>(
    Future<T> Function() apiCall,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await apiCall();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: "No Internet connection"));
    }
  }

  @override
  Future<Either<Failures, List<String>>> getAllCategories() async {
    return _hadelNetworkRequest(() => remoteDataSource.getAllCategories());
  }

  @override
  Future<Either<Failures, List<ProductsEntity>>> getProducts({
    int limit = 20,
    int skip = 0,
  }) async {
    return _hadelNetworkRequest(
      () => remoteDataSource.getProducts(limit: limit, skip: skip),
    );
  }

  @override
  Future<Either<Failures, ProductsEntity>> getProductById(int id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failures, List<ProductsEntity>>> getProductsByCategory(
    String categoryName,
  ) async {
    return _hadelNetworkRequest(
      () => remoteDataSource.getProductsByCategory(categoryName),
    );
  }

  @override
  Future<Either<Failures, List<ProductsEntity>>> searchProducts({
    required String query,
    int limt = 20,
    int skip = 0,
  }) async {
    return _hadelNetworkRequest(
      () => remoteDataSource.searchProducts(
        query: query,
        limit: limt,
        skip: skip,
      ),
    );
  }
}
