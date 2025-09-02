import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class UserRegistrationRequest extends Equatable {
  final String email;
  final String password;
  @JsonKey(name: 'display_name')
  final String? displayName;

  const UserRegistrationRequest({
    required this.email,
    required this.password,
    this.displayName,
  });

  factory UserRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$UserRegistrationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserRegistrationRequestToJson(this);

  @override
  List<Object?> get props => [email, password, displayName];
}

@JsonSerializable()
class LoginRequest extends Equatable {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  @override
  List<Object?> get props => [email, password];
}

@JsonSerializable()
class TokenResponse extends Equatable {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'token_type')
  final String tokenType;
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  const TokenResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshToken,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);

  @override
  List<Object?> get props => [accessToken, tokenType, expiresIn, refreshToken];
}

@JsonSerializable()
class UserResponse extends Equatable {
  @JsonKey(name: 'user_id')
  final String userId;
  final String email;
  @JsonKey(name: 'display_name')
  final String? displayName;
  final List<String> roles;
  @JsonKey(name: 'subscription_status')
  final String subscriptionStatus;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const UserResponse({
    required this.userId,
    required this.email,
    this.displayName,
    required this.roles,
    required this.subscriptionStatus,
    required this.createdAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);

  @override
  List<Object?> get props => [userId, email, displayName, roles, subscriptionStatus, createdAt];
}