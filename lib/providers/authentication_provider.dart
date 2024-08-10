// Proveedor para manejar el estado de inicio de sesión
import 'package:riverpod/riverpod.dart';

/* final authProvider = StateProvider<AuthState>((ref) => AuthState.initial());

// Proveedor para la lógica de autenticación
final authServiceProvider =
    Provider<AuthService>((ref) => AuthService(ref.read));

class AuthState {
  final bool isAuthenticated;
  final String? email;
  final String? errorMessage;

  AuthState._({
    required this.isAuthenticated,
    this.email,
    this.errorMessage,
  });

  factory AuthState.initial() => AuthState._(isAuthenticated: false);

  factory AuthState.authenticated(String email) => AuthState._(
        isAuthenticated: true,
        email: email,
      );

  factory AuthState.error(String message) => AuthState._(
        isAuthenticated: false,
        errorMessage: message,
      );
} */
