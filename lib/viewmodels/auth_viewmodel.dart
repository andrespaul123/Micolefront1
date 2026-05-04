import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/users.dart';
import '../repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;

  Users? user;
  String? token;
  bool loading = false;

  AuthViewModel({required this.repository});

  // ================= GETTERS =================

  String? get role {
    if (user == null || user!.roles.isEmpty) return null;
    return user!.roles.first;
  }

  bool get isLoggedIn => token != null;

  // ================= LOGIN =================

  Future<bool> login(String email, String password) async {
    loading = true;
    notifyListeners();

    final response = await repository.login(email, password);

<<<<<<< Updated upstream
    if (response != null) {
      user = response;
      token = response.token;

      // 🔥 GUARDAR SESIÓN
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.token);
      await prefs.setString('role', response.roles.first);
      await prefs.setString('name', response.name);
      await prefs.setString('email', response.email);

      print("✅ LOGIN OK");
    } else {
      print("❌ LOGIN FALLIDO");
=======
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
    } on DioException catch (e) {
      final data = e.response?.data;

       if (data != null &&
          data['errors'] != null &&
          data['errors']['email'] != null) {
        loginError = data['errors']['email'][0].toString();
      } else if (data != null &&
          data['errors'] != null &&
          data['errors']['password'] != null) {
        loginError = data['errors']['password'][0].toString();
      } else {
        loginError = data?['message']?.toString() ?? 'Error de conexión';
      }
       if (loginError == 'The email must be a valid email address.') {
       loginError = 'Correo inválido';
  }
  if (loginError == 'Credenciales incorrectas') {
  loginError = 'Correo o contraseña incorrectos';
}

      if (kDebugMode) debugPrint('❌ LOGIN ERROR: $loginError');

      return false;
    } catch (e) {
      loginError = 'Error inesperado';

      if (kDebugMode) debugPrint('❌ LOGIN ERROR: $e');

      return false;
    } finally {
      loading = false;
      notifyListeners();
>>>>>>> Stashed changes
    }

    loading = false;
    notifyListeners();

    return user != null;
  }

  // ================= REGISTER =================

  Future<bool> register(
      String name, String email, String password) async {
    loading = true;
    notifyListeners();

    final response = await repository.register(
      name: name,
      email: email,
      password: password,
    );

<<<<<<< Updated upstream
    if (response != null) {
      user = response;
      token = response.token;

      // 🔥 GUARDAR SESIÓN (opcional)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.token);
      await prefs.setString('role', response.roles.first);
      await prefs.setString('name', response.name);
      await prefs.setString('email', response.email);

      print("✅ REGISTER OK");
    } else {
      print("❌ REGISTER FALLIDO");
=======
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
    } on DioException catch (e) {
      final data = e.response?.data;

      loginError =
          data?['errors']?['name']?.first ??
          data?['errors']?['email']?.first ??
          data?['errors']?['password']?.first ??
          data?['message'] ??
          'Error de conexión';
  
    if (loginError == 'The email has already been tak en.') {
  loginError = 'El correo ya está registrado';
}
if (loginError == 'The email must be a valid email address.') {
  loginError = 'Correo inválido';
}
if (loginError == 'The password must be at least 6 characters.') {
  loginError = 'La contraseña debe tener al menos 6 caracteres';
}


      if (kDebugMode) debugPrint('❌ REGISTER ERROR: $loginError');

      return false;
    } catch (e) {
      loginError = 'Error inesperado';

      if (kDebugMode) debugPrint('❌ REGISTER ERROR: $e');

      return false;
    } finally {
      loading = false;
      notifyListeners();
>>>>>>> Stashed changes
    }

    loading = false;
    notifyListeners();

    return user != null;
  }

  // ================= LOAD SESSION =================

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    final savedToken = prefs.getString('token');
    final savedRole = prefs.getString('role');
    final savedName = prefs.getString('name');
    final savedEmail = prefs.getString('email');

    if (savedToken != null) {
      token = savedToken;

<<<<<<< Updated upstream
=======
    if (session['token'] != null) {
      token = session['token'];

>>>>>>> Stashed changes
      user = Users(
        id: null,
        name: savedName ?? '',
        email: savedEmail ?? '',
        token: savedToken,
        roles: savedRole != null ? [savedRole] : [],
      );

<<<<<<< Updated upstream
      print("🔁 SESIÓN RESTAURADA");
      print("Token: $savedToken");
      print("Role: $savedRole");
=======
      if (kDebugMode) debugPrint('🔁 SESIÓN RESTAURADA');
>>>>>>> Stashed changes

      notifyListeners();
    }
  }

  // ================= LOGOUT =================

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear(); // 🔥 borra sesión local

    try {
      await repository.logout(); // 🔥 backend
    } catch (e) {
      print("Error logout: $e");
    }

    user = null;
    token = null;

<<<<<<< Updated upstream
    print("🔓 SESIÓN CERRADA");
=======
    if (kDebugMode) debugPrint('🔓 SESIÓN CERRADA');
>>>>>>> Stashed changes

    notifyListeners();
  }
}