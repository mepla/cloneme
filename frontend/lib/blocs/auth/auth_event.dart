import 'package:equatable/equatable.dart';
import '../../models/auth_models.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthRegistrationRequested extends AuthEvent {
  final String email;
  final String password;
  final String? displayName;

  const AuthRegistrationRequested({
    required this.email,
    required this.password,
    this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthTokenRefreshRequested extends AuthEvent {}

class AuthUserLoaded extends AuthEvent {
  final UserResponse user;

  const AuthUserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}