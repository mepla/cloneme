import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/auth/auth_state.dart';
import 'core/theme/dashboard_colors.dart';
import 'repositories/auth_repository.dart';
import 'services/api_client.dart';
import 'services/secure_storage_service.dart';
import 'widgets/evermynd_logo.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/dashboard/dashboard_main_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiClient>(
          create: (context) => ApiClient(),
        ),
        RepositoryProvider<SecureStorageService>(
          create: (context) => SecureStorageService(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            apiClient: context.read<ApiClient>(),
            storage: context.read<SecureStorageService>(),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
          storageService: context.read<SecureStorageService>(),
        )..add(AuthStarted()),
        child: MaterialApp(
          title: 'EverMynd',
          debugShowCheckedModeBanner: false,
          theme: DashboardTheme.lightTheme,
          home: const AuthWrapper(),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const SplashScreen();
        } else if (state is AuthAuthenticated) {
          // Check if user has Creator role and redirect to dashboard
          if (state.user.roles.contains('Creator')) {
            return const DashboardMainScreen();
          }
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8C52FF), Color(0xFF4D0F99)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 80,
              ),
              const SizedBox(height: 24),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, Colors.white70],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const EvermyndLogo(size: LogoSize.large),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
