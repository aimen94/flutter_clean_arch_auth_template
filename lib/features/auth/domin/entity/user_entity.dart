import 'package:equatable/equatable.dart';

/// Domain entity representing a user's core profile information
///
/// This class represents the user domain model that is used throughout
/// the business logic layer. It extends Equatable for value comparison
/// and provides computed properties for user information.
///
/// The entity contains only the essential user data needed for
/// business operations, without any data layer dependencies.
class UserEntity extends Equatable {
  /// Unique identifier for the user
  final int id;

  /// User's unique username for login and identification
  final String username;

  /// User's email address for communication
  final String email;

  /// User's first name for personal identification
  final String firstName;

  /// User's last name for personal identification
  final String lastName;

  /// User's gender for personalization
  final String gender;

  /// URL to user's profile image
  final String image;

  /// Creates a UserEntity with all required user information
  ///
  /// [id] - Unique user identifier
  /// [username] - User's unique username
  /// [email] - User's email address
  /// [firstName] - User's first name
  /// [lastName] - User's last name
  /// [gender] - User's gender
  /// [image] - URL to user's profile image
  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.image,
  });

  @override
  /// Defines the properties used for value equality comparison
  ///
  /// Returns a list of properties that determine entity equality
  /// Used by Equatable for comparing UserEntity instances
  List<Object?> get props => [
    id,
    username,
    email,
    firstName,
    lastName,
    gender,
    image,
  ];

  /// Computed property for user's full name
  ///
  /// Returns the concatenated first and last name
  /// Used for display purposes throughout the application
  String get fullName => '$firstName $lastName';
}

/// Domain entity representing a product in the system
///
/// This class represents a product entity that may be used
/// in future features or extensions of the application.
///
/// Contains basic product information including vendor details,
/// availability, pricing, and identification.
class ProductEntity {
  /// Unique identifier for the vendor selling the product
  final int vendorId;

  /// Indicates whether the product is currently in stock
  final bool inStock;

  /// Product price in USD as a string
  final String priceUsd;

  /// Human-readable name of the product
  final String productName;

  /// Unique identifier for the product
  final int productId;

  /// Creates a ProductEntity with all required product information
  ///
  /// [vendorId] - ID of the vendor selling the product
  /// [inStock] - Whether the product is currently available
  /// [priceUsd] - Product price in US dollars
  /// [productName] - Name/description of the product
  /// [productId] - Unique identifier for the product
  ProductEntity({
    required this.vendorId,
    required this.inStock,
    required this.priceUsd,
    required this.productName,
    required this.productId,
  });
}
