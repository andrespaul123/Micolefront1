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

      user = Users(
        id: null,
        name: savedName ?? '',
        email: savedEmail ?? '',
        token: savedToken,
        roles: savedRole != null ? [savedRole] : [],
      );

      print("🔁 SESIÓN RESTAURADA");
      print("Token: $savedToken");
      print("Role: $savedRole");

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

    print("🔓 SESIÓN CERRADA");

    notifyListeners();
  }
}