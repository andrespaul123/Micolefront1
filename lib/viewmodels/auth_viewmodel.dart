import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/users.dart';
import '../repository/auth_repository.dart';
import '../core/storage/secure_storage.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;

  Users? user;
  String? token;
  bool loading = false;
  String? loginError;

  AuthViewModel({required this.repository});

  String? get role {
    if (user == null || user!.roles.isEmpty) return null;
    return user!.roles.first;
  }

  bool get isLoggedIn => token != null;

  Future<bool> login(String email, String password) async {
    loading = true;
    loginError = null;
    notifyListeners();

    try {
      final response = await repository.login(email, password);

      if (response != null) {
        user = response;
        token = response.token;
        
        await SecureStorage.saveSession(
          token: response.token,
          role: response.roles.first,
          name: response.name,
          email: response.email,
        );
        
        if (kDebugMode) debugPrint('✅ LOGIN OK');
        return true;
      } else {
        loginError = 'Credenciales inválidas';
        return false;
      }
    } on DioException catch (e) {
      loginError = e.response?.data?['message'] ?? 'Error de conexión';
      if (kDebugMode) debugPrint('❌ LOGIN ERROR: $e');
      return false;
    } catch (e) {
      loginError = 'Error inesperado';
      if (kDebugMode) debugPrint('❌ LOGIN ERROR: $e');
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    loading = true;
    loginError = null;
    notifyListeners();

    try {
      final response = await repository.register(
        name: name,
        email: email,
        password: password,
      );

      if (response != null) {
        user = response;
        token = response.token;

        await SecureStorage.saveSession(
          token: response.token,
          role: response.roles.first,
          name: response.name,
          email: response.email,
        );

        if (kDebugMode) debugPrint('✅ REGISTER OK');
        return true;
      } else {
        loginError = 'Error al registrarse';
        return false;
      }
    } on DioException catch (e) {
      loginError = e.response?.data?['message'] ?? 'Error de conexión';
      return false;
    } catch (e) {
      loginError = 'Error inesperado';
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> loadSession() async {
    final session = await SecureStorage.getSession();

    if (session['token'] != null) {
      token = session['token'];
      user = Users(
        id: null,
        name: session['name'] ?? '',
        email: session['email'] ?? '',
        token: session['token']!,
        roles: session['role'] != null ? [session['role']!] : [],
      );
      if (kDebugMode) debugPrint('🔁 SESIÓN RESTAURADA');
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await repository.logout();
    } catch (_) {}

    await SecureStorage.clear();

    user = null;
    token = null;

    if (kDebugMode) debugPrint('🔓 SESIÓN CERRADA');
    notifyListeners();
  }
}