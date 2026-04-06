import 'package:flutter/material.dart';
import '../models/tenant_response.dart';
import '../repository/tenant_repository.dart';

class TenantViewModel extends ChangeNotifier {
  final TenantRepository repository;

  bool loading = false;
  TenantResponse? tenant;

  TenantViewModel({required this.repository});

  Future<bool> createTenant({
    required String name,
    required String slug,
    required String directorName,
    required String directorEmail,
    required String password,
  }) async {
    loading = true;
    notifyListeners();

    tenant = await repository.createTenant(
      name: name,
      slug: slug,
      directorName: directorName,
      directorEmail: directorEmail,
      password: password,
    );

    loading = false;
    notifyListeners();

    return tenant != null;
  }
}