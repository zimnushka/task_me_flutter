import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:task_me_flutter/layers/models/api_response.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/api.dart';

class UserApiRepository extends ApiRepository {
  Future<ApiResponse<User?>> getUserMe() async {
    try {
      final data = await client.get('/user/me');

      return ApiResponse(
          data: User.fromJson(jsonDecode(data.data as String)),
          isSuccess: true,
          message: null,
          statusCode: data.statusCode!);
    } catch (e) {
      return ApiResponse(data: null, isSuccess: false, message: e.toString(), statusCode: 408);
    }
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

  Future<bool> addMemberToProject(String email, int projectId) async {
    late final Response data;
    try {
      data = await client.put('/projectMembers/$projectId?email=$email');
    } catch (e) {
      return false;
    }
    return ApiResponse.isSuccessStatusCode(data.statusCode ?? 0);
  }

  Future<bool> deleteMemberFromProject(int userId, int projectId) async {
    late final Response data;
    try {
      data = await client.delete('/projectMembers/$projectId?userId=$userId');
    } catch (e) {
      return false;
    }
    return ApiResponse.isSuccessStatusCode(data.statusCode ?? 0);
  }
}
