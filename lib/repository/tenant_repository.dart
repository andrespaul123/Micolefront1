import 'package:dio/dio.dart';
import '../models/tenant_response.dart';
import '../models/tenant.dart';

class TenantRepository {
  final Dio _dio;

  TenantRepository(this._dio);

  Future<List<Tenant>> getTenants() async {
    try {
      final response = await _dio.get('/tenants');
      return (response.data as List)
          .map((e) => Tenant.fromJson(e))
          .toList();
    } catch (e) {
      if (e is DioException) {
        print("ERROR GET TENANTS: ${e.response?.data}");
      }
      return [];
    }
  }

  /* Future<Tenant?> getMyTenant() async {
  try {
    final response = await _dio.get('/my-tenant');

    return Tenant.fromJson(response.data['data']);
  } catch (e) {
    if (e is DioException) {
      print("ERROR MY TENANT: ${e.response?.data}");
    }
    return null;
  }
} */
Future<Tenant?> getMyTenant() async {
  try {
    final response = await _dio.get('/my-tenant');

    final data = response.data['data'];

    data['logo_url'] = response.data['logo_url'];

    return Tenant.fromJson(data);
  } catch (e) {
    return null;
  }
}

  Future<TenantResponse?> createTenant({
    required String name,
    required String slug,
    required String directorName,
    required String directorEmail,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/tenants',
        data: {
          'name': name,
          'slug': slug,
          'director_name': directorName,
          'director_email': directorEmail,
          'password': password,
        },
      );

      print("TENANT RESPONSE: ${response.data}");

      return TenantResponse.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        print("TENANT ERROR: ${e.response?.data}");
      }
      return null;
    }
  }

  Future<bool> uploadLogo(List<int> bytes, String filename) async {
  try {
    final formData = FormData.fromMap({
      'logo': MultipartFile.fromBytes(bytes, filename: filename),
    });
    await _dio.post('/tenants/logo', data: formData);
    return true;
  } catch (e) {
    if (e is DioException) print("ERROR LOGO: ${e.response?.data}");
    return false;
  }
}

  // 🔥 EDITAR nombre y slug
  Future<Tenant?> updateTenant({
    required String name,
    required String slug,
  }) async {
    try {
      final response = await _dio.put('/tenants', data: {
        'name': name,
        'slug': slug,
      });
      return Tenant.fromJson(response.data['data']);
    } catch (e) {
      if (e is DioException) print("ERROR UPDATE TENANT: ${e.response?.data}");
      return null;
    }
  }

  Future<bool> deleteTenant(int id) async {
    try {
      await _dio.delete('/tenants/$id');
      return true;
    } catch (e) {
      if (e is DioException) print("ERROR DELETE TENANT: ${e.response?.data}");
      return false;
    }
  }

}