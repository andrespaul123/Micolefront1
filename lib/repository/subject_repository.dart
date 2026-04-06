import 'package:dio/dio.dart';
import '../models/subject.dart';

class SubjectRepository {
  final Dio _dio;

  SubjectRepository(this._dio);

  // 🔥 CREAR
  Future<Subject?> createSubject(String name) async {
    try {
      final response = await _dio.post(
        '/subjects',
        data: {
          'name': name,
        },
      );

      print("CREATE SUBJECT: ${response.data}");

      return Subject.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        print("ERROR CREATE SUBJECT: ${e.response?.data}");
      }
      return null;
    }
  }

  // 🔥 LISTAR
  Future<List<Subject>> getSubjects() async {
    try {
      final response = await _dio.get('/subjects');

      print("GET SUBJECTS: ${response.data}");

      return (response.data as List)
          .map((e) => Subject.fromJson(e))
          .toList();
    } catch (e) {
      if (e is DioException) {
        print("ERROR GET SUBJECTS: ${e.response?.data}");
      }
      return [];
    }
  }
}