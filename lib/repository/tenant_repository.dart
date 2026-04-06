import 'package:dio/dio.dart';
import '../models/tenant_response.dart';

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
}