// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegistrationRequest _$UserRegistrationRequestFromJson(
  Map<String, dynamic> json,
) => UserRegistrationRequest(
  email: json['email'] as String,
  password: json['password'] as String,
  displayName: json['display_name'] as String?,
);

Map<String, dynamic> _$UserRegistrationRequestToJson(
  UserRegistrationRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'display_name': instance.displayName,
};

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    TokenResponse(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$TokenResponseToJson(TokenResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
      'refresh_token': instance.refreshToken,
    };

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
  userId: json['user_id'] as String,
  email: json['email'] as String,
  displayName: json['display_name'] as String?,
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
  subscriptionStatus: json['subscription_status'] as String,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'email': instance.email,
      'display_name': instance.displayName,
      'roles': instance.roles,
      'subscription_status': instance.subscriptionStatus,
      'created_at': instance.createdAt,
    };
