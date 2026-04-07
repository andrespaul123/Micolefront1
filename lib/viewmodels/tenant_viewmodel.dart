import 'package:flutter/material.dart';
import '../models/tenant_response.dart';
import '../repository/tenant_repository.dart';
import '../models/tenant.dart';
import 'package:image_picker/image_picker.dart';

class TenantViewModel extends ChangeNotifier {
  final TenantRepository repository;

  bool loading = false;
  TenantResponse? tenant;
   Tenant? currentTenant;

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

  // 🔥 CAMBIAR firma
Future<bool> uploadLogo(XFile file) async {
  loading = true;
  notifyListeners();

  final bytes = await file.readAsBytes();
  final success = await repository.uploadLogo(bytes, file.name);

  loading = false;
  notifyListeners();
  return success;
}

  // 🔥 EDITAR nombre y slug
  Future<bool> updateTenant({
    required String name,
    required String slug,
  }) async {
    loading = true;
    notifyListeners();

    final updated = await repository.updateTenant(name: name, slug: slug);

    if (updated != null) {
      currentTenant = updated;
    }

    loading = false;
    notifyListeners();
    return updated != null;
  }
}