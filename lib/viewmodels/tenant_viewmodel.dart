import 'package:flutter/material.dart';
import '../models/tenant_response.dart';
import '../repository/tenant_repository.dart';
import '../models/tenant.dart';
import 'package:image_picker/image_picker.dart';

class TenantViewModel extends ChangeNotifier {
  final TenantRepository repository;

  bool loading = false;
  bool creating = false;
  bool updating = false;
  bool uploading = false;
  TenantResponse? tenant;
   Tenant? currentTenant;
   List<Tenant> tenants = [];

  TenantViewModel({required this.repository});

  Future<void> loadTenants() async {
    loading = true;
    notifyListeners();

    tenants = await repository.getTenants();

    loading = false;
    notifyListeners();
  }

  Future<void> loadMyTenant() async {
  loading = true;
  notifyListeners();

  currentTenant = await repository.getMyTenant();

  loading = false;
  notifyListeners();
  }

   Future<bool> createTenant({
    required String name,
    required String slug,
    required String directorName,
    required String directorEmail,
    required String password,
  }) async {
    if (creating) return false;

    creating = true;
    notifyListeners();

    try {
      tenant = await repository.createTenant(
        name: name,
        slug: slug,
        directorName: directorName,
        directorEmail: directorEmail,
        password: password,
      );

      if (tenant != null) {
        await loadTenants();
      }

      return tenant != null;
    } finally {
      creating = false;
      notifyListeners();
    }
  }

  // 🔥 CAMBIAR firma
Future<bool> uploadLogo(XFile file) async {
    if (uploading) return false;

    uploading = true;
    notifyListeners();

    final bytes = await file.readAsBytes();
    final success = await repository.uploadLogo(bytes, file.name);

    uploading = false;
    notifyListeners();
    return success;
  }


  // 🔥 EDITAR nombre y slug
 Future<bool> updateTenant({
    required String name,
    required String slug,
  }) async {
    if (updating) return false;

    updating = true;
    notifyListeners();

    try {
      final updated = await repository.updateTenant(
        name: name,
        slug: slug,
      );

      if (updated != null) {
        currentTenant = updated;
      }

      return updated != null;
    } finally {
      updating = false;
      notifyListeners();
    }
  }

   Future<bool> deleteTenant(int id) async {
    loading = true;
    notifyListeners();

    final success = await repository.deleteTenant(id);

    if (success) await loadTenants();

    loading = false;
    notifyListeners();
    return success;
  }
}