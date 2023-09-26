import 'dart:convert';
import 'package:task_me_flutter/domain/models/api_response.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/repositories/api/api.dart';

class UserApiRepository extends ApiRepository {
  Future<ApiResponse<User?>> getUserMe() async {
    return ApiErrorHandler(() async {
      final data = await client.get('/user/me');
      return ApiResponse(
        body: User.fromJson(data.data),
        status: data.statusCode!,
      );
    }).result;
  }

  Future<ApiResponse<List<User>?>> getUserFromProject(int projectId) async {
    return ApiErrorHandler(() async {
      final data = await client.get('/project/member/$projectId');

      return ApiResponse(
          // ignore: unnecessary_lambdas
          body: (data.data as List).map((e) => User.fromJson(e)).toList(),
          status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<List<User>?>> getUserFromTask(int taskId) async {
    return ApiErrorHandler(() async {
      final data = await client.get('/task/member/$taskId');
      return ApiResponse(
          // ignore: unnecessary_lambdas
          body: (data.data as List).map((e) => User.fromJson(e)).toList(),
          status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<User?>> editUser(User user) async {
    return ApiErrorHandler(() async {
      final data = await client.put('/user', data: user.toJson());
      return ApiResponse(body: user, status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<bool?>> updateTaskMemberList(int taskId, List<User> users) async {
    return ApiErrorHandler(() async {
      final jsonData = users.map((e) => e.toJson()).toList();
      final data = await client.post('/task/member/$taskId', data: jsonEncode(jsonData));
      return ApiResponse(body: true, status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<bool?>> addMemberToProject(String email, int projectId) async {
    return ApiErrorHandler(() async {
      final data = await client.put('/project/member/$projectId?email=$email');
      return ApiResponse(body: true, status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<bool?>> deleteMemberFromProject(int userId, int projectId) async {
    return ApiErrorHandler(() async {
      final data = await client.delete('/project/member/$projectId?userId=$userId');
      return ApiResponse(body: true, status: data.statusCode!);
    }).result;
  }
}
