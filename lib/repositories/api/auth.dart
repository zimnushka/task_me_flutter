part of 'api.dart';

extension AuthApiExt on ApiRepository {
  Future<ApiResponse<String?>> signIn(String email, String password) async {
    return ApiErrorHandler(() async {
      final data = await client.post('/auth/login', data: {'email': email, 'password': password});
      return ApiResponse(body: data.data as String, status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<String?>> signUp(String email, String password, String name) async {
    return ApiErrorHandler(() async {
      final data = await client.post(
        '/auth/registration',
        data: {'email': email, 'password': password, 'name': name},
      );
      return ApiResponse(body: data.data as String, status: data.statusCode!);
    }).result;
  }
}
