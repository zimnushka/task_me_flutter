import 'package:task_me_flutter/domain/models/api_response.dart';
import 'package:task_me_flutter/repositories/api/api.dart';

class AuthApiRepository extends ApiRepository {
  Future<ApiResponse<String?>> login(String email, String password) async {
    return ApiErrorHandler(() async {
      final data = await client.post('/auth/login', data: {'email': email, 'password': password});
      return ApiResponse(body: data.data as String, status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<String?>> registration(String email, String password, String name) async {
    return ApiErrorHandler(() async {
      final data = await client.post(
        '/auth/registration',
        data: {'email': email, 'password': password, 'name': name},
      );
      return ApiResponse(body: data.data as String, status: data.statusCode!);
    }).result;
  }
}
