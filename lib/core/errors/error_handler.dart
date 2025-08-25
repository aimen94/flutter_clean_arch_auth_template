// import 'package:dio/dio.dart';
// import 'package:flutter_application_2/core/constants/api_endpoints.dart';
// import 'package:flutter_application_2/core/errors/failures.dart';

// class ErrorHandler {
//   static Failures handleError(dynamic error) {
//     if (error is DioException) {
//       return _handleDioError(error);
//     } else if (error is CacheFailure) {
//       return CacheFailure(error.message, message: '');
//     } else if (error is NetworkFailure) {
//       return NetworkFailure();
//     } else {
//       return Failures('An unexpected error occurred');
//     }
//   }

//   static Failures _handleDioError(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//       case DioExceptionType.sendTimeout:
//       case DioExceptionType.receiveTimeout:
//         return NetworkFailure();
//       case DioExceptionType.badResponse:
//         return _handleResponseError(error);
//       default:
//         return NetworkFailure();
//     }
//   }

//   static Failures _handleResponseError(DioException error) {
//     final statusCode = error.response?.statusCode;
//     final message = error.response?.data['message'] ?? 'حدث خطأ في الخادم';
//     switch (statusCode) {
//       case 400:
//         return ServerFailure(message);
//       case 401:
//         return ServerFailure(AppStrings.unauthorized);
//       case 403:
//         return ServerFailure(AppStrings.sessionExpired);
//       case 404:
//         return ServerFailure('المورد غير موجود');
//       case 500:
//         return ServerFailure(AppStrings.serverError);
//       default:
//         return ServerFailure(message);
//     }
//   }
// }
