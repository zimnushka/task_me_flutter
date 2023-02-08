import 'dart:convert';
import 'package:task_me_flutter/layers/models/api_response.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/api.dart';

class UserApiRepository extends ApiRepository {
  Future<ApiResponse<User?>> getUserMe() async {
    return ApiErrorHandler(() async {
      final data = await client.get('/user/me');
      return ApiResponse(
        body: User.fromJson(jsonDecode(data.data as String)),
        status: data.statusCode!,
      );
    }).result;
  }

  Future<ApiResponse<List<User>?>> getUserFromProject(int projectId) async {
    return ApiErrorHandler(() async {
      final data = await client.get('/projectMembers/$projectId');
      final jsonData = jsonDecode(data.data);
      return ApiResponse(
          // ignore: unnecessary_lambdas
          body: (jsonData as List).map((e) => User.fromJson(e)).toList(),
          status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<User?>> editUser(User user) async {
    return ApiErrorHandler(() async {
      final data = await client.put('/user/', data: user.toJson());
      return ApiResponse(body: user, status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<bool?>> addMemberToProject(String email, int projectId) async {
    return ApiErrorHandler(() async {
      final data = await client.put('/projectMembers/$projectId?email=$email');
      return ApiResponse(body: true, status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<bool?>> deleteMemberFromProject(int userId, int projectId) async {
    return ApiErrorHandler(() async {
      final data = await client.delete('/projectMembers/$projectId?userId=$userId');
      return ApiResponse(body: true, status: data.statusCode!);
    }).result;
  }
}
