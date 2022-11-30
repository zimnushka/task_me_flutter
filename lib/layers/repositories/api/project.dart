import 'dart:convert';

import 'package:task_me_flutter/layers/models/api_response.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/api.dart';

class ProjectApiRepository extends ApiRepository {
  Future<ApiResponse<List<Project>?>> getAll() async {
    final data = await client.get('/project');
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      final jsonData = jsonDecode(data.data);
      return ApiResponse(
          // ignore: unnecessary_lambdas
          data: (jsonData as List).map((e) => Project.fromJson(e)).toList(),
          isSuccess: true,
          message: null,
          statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: null, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }

  Future<ApiResponse<Project?>> getById(int id) async {
    final data = await client.get('/project/$id');
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      return ApiResponse(
          data: Project.fromJson(jsonDecode(data.data)),
          isSuccess: true,
          message: null,
          statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: null, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }

  Future<ApiResponse<bool>> add(Project project) async {
    final data = await client.post('/project', data: project.toJson());
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      return ApiResponse(data: true, isSuccess: true, message: null, statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: false, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }

  Future<ApiResponse<String?>> edit(String email, String password, String name) async {
    final data = await client
        .post('/project/registration', data: {'email': email, 'password': password, 'name': name});
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      return ApiResponse(
          data: data.data as String, isSuccess: true, message: null, statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: null, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }

  Future<ApiResponse<String?>> delete(String email, String password, String name) async {
    final data = await client
        .post('/project/registration', data: {'email': email, 'password': password, 'name': name});
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      return ApiResponse(
          data: data.data as String, isSuccess: true, message: null, statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: null, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }
}
