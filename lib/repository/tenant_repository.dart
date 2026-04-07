import 'package:dio/dio.dart';
import '../models/tenant_response.dart';
import '../models/tenant.dart';

class TenantRepository {
  final Dio _dio;

  TenantRepository(this._dio);

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
}