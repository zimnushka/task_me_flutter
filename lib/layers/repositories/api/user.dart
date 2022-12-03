import 'dart:convert';

import 'package:task_me_flutter/layers/models/api_response.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/api.dart';

class UserApiRepository extends ApiRepository {
  Future<ApiResponse<User?>> getUserMe() async {
    final data = await client.get('/user/me');
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      return ApiResponse(
          data: User.fromJson(jsonDecode(data.data as String)),
          isSuccess: true,
          message: null,
          statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: null, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }

  Future<ApiResponse<List<User>?>> getUserFromProject(int projectId) async {
    final data = await client.get('/projectMembers/$projectId');
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      final jsonData = jsonDecode(data.data);
      return ApiResponse(
          // ignore: unnecessary_lambdas
          data: (jsonData as List).map((e) => User.fromJson(e)).toList(),
          isSuccess: true,
          message: null,
          statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: null, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }

  Future<ApiResponse<User?>> editUser(User user) async {
    final data = await client.put('/user/', data: user.toJson());
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      return ApiResponse(data: user, isSuccess: true, message: null, statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: null, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }
}
