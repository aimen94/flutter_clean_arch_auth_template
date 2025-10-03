import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_application_2/core/constants/api_endpoints.dart';
import 'package:flutter_application_2/core/errors/exceptions.dart';
import 'package:flutter_application_2/core/network/dio_client.dart';
import 'package:flutter_application_2/features/products/data/models/products_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({int limit = 20, int skip = 0});
  Future<ProductModel> getProductById(int id);
  Future<List<ProductModel>> getProductsByCategory({
    required String categoryName,
    required int limit,
    required int skip,
  });
  Future<List<String>> getAllCategories();
  Future<List<ProductModel>> searchProducts({
    required String query,
    int limit = 20,
    int skip = 0,
  });
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  DioClient _dioClient;
  ProductRemoteDataSourceImpl(this._dioClient);

  Future<T> _handleApiRequestForObject<T>({
    required Future<Response> Function() apiRequest,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    try {
      final response = await apiRequest();
      if (response.statusCode == 200) {
        return fromJson(response.data);
      } else {
        throw ServerException(
          message: 'server errorr',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e', statusCode: 500);
    }
  }

  Future<List<T>> _handleApiRequestForList<T>({
    required Future<Response> Function() apiRequest,
    required T Function(Map<String, dynamic> json) fromJson,
    required String listKey,
  }) async {
    try {
      final response = await apiRequest();
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data[listKey];
        return jsonList
            .map((json) => fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: 'server errorr',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e', statusCode: 500);
    }
  }

  @override
  Future<List<ProductModel>> getProducts({int limit = 20, int skip = 0}) async {
    final queryParameters = {'limit': limit, 'skip': skip};
    return _handleApiRequestForList<ProductModel>(
      apiRequest: () => _dioClient.get(
        ApiEndpoints.products,
        queryParameters: queryParameters,
      ),
      fromJson: (json) => ProductModel.fromJson(json),
      listKey: 'products',
    );
  }

  @override
  Future<List<String>> getAllCategories() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.allCategories);
      if (response.statusCode == 200) {
        return List<String>.from(response.data);
      } else {
        throw ServerException(
          message: 'Field to load categories',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'network error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e', statusCode: 500);
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory({
    required String categoryName,
    required int limit,
    required int skip,
  }) async {
    return _handleApiRequestForList(
      apiRequest: () =>
          _dioClient.get('${ApiEndpoints.categoryProducts}/$categoryName'),
      fromJson: (json) => ProductModel.fromJson(json),
      //listKey: 'category',
      listKey: 'products',
    );
  }

  @override
  Future<List<ProductModel>> searchProducts({
    required String query,
    int limit = 20,
    int skip = 0,
  }) async {
    return _handleApiRequestForList<ProductModel>(
      apiRequest: () => _dioClient.get(
        ApiEndpoints.searchProducts,
        queryParameters: {'q': query, 'limit': limit, 'skip': skip},
      ),
      fromJson: (json) => ProductModel.fromJson(json),
      listKey: 'products',
    );
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    return _handleApiRequestForObject(
      apiRequest: () => _dioClient.get('${ApiEndpoints.products}/$id'),
      fromJson: (json) => ProductModel.fromJson(json),
    );
  }
}
