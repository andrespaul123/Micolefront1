import 'package:dio/dio.dart';
import '../models/users.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl:  "http://192.168.137.232:8000/api",
                connectTimeout: const Duration(seconds: 5),
                receiveTimeout: const Duration(seconds: 5),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            );

  // LOGIN
  Future<Users?> login(String email, String password) async {
    try {
      final response = await _dio.post(
       '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return Users.fromJson(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // REGISTER
 Future<Users?> register({
  required String name,
  required String email,
  required String password,
}) async {
  try {
    final response = await _dio.post(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'role': 'super-admin', // 🔥 AGREGA ESTO */
      },
    );

    return Users.fromJson(response.data);
  } catch (e) {
  if (e is DioException) {
    print("ERROR BACKEND: ${e.response?.data}");
  } else {
    print("ERROR: $e");
  }
  return null;
}
}

Future<void> logout() async {
  try {
    await _dio.post('/auth/logout');
  } catch (e) {
    print("ERROR LOGOUT: $e");
  }
}
}