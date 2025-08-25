import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Abstract interface for checking network connectivity status
///
/// This interface provides a contract for network information services
/// that can determine whether the device has internet access.
///
/// Used throughout the application to check network availability
/// before making API calls or performing network operations.
abstract class NetworkInfo {
  /// Returns a Future<bool> indicating whether the device has internet access
  ///
  /// Returns true if internet connection is available, false otherwise
  Future<bool> get isConnected;
}

/// Implementation of NetworkInfo interface using InternetConnectionChecker
///
/// This class provides concrete implementation for checking network connectivity
/// using the internet_connection_checker_plus package.
///
/// The implementation delegates to the InternetConnection service to
/// determine actual network availability status.
class NetworkInfoImpl implements NetworkInfo {
  /// Internet connection checker service instance
  final InternetConnection connectionChecker;

  /// Creates a NetworkInfoImpl with the required connection checker
  ///
  /// [connectionChecker] - Service for checking internet connectivity
  NetworkInfoImpl(this.connectionChecker);

  @override
  /// Checks if the device has internet access
  ///
  /// Delegates the network check to the connection checker service
  /// Returns a Future<bool> indicating connectivity status
  Future<bool> get isConnected => connectionChecker.hasInternetAccess;
}
