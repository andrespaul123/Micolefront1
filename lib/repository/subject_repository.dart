import 'package:dio/dio.dart';
import '../models/subject.dart';

class SubjectRepository {
  final Dio _dio;

  SubjectRepository(this._dio);

  // 🔥 CREAR
  Future<Subject> createSubject(String name) async {
      final response = await _dio.post( '/subjects',
        data: {
          'name': name,},
      );

      print("CREATE SUBJECT: ${response.data}");

      return Subject.fromJson(response.data);
    }
  

  // 🔥 LISTAR
  Future<List<Subject>> getSubjects() async {
      final response = await _dio.get('/subjects');
        
    return (response.data as List)
        .map((e) => Subject.fromJson(e))
        .toList();
  }
}