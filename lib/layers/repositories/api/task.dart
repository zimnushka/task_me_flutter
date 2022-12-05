import 'dart:convert';

import 'package:task_me_flutter/layers/models/api_response.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/api.dart';

class TaskApiRepository extends ApiRepository {
  Future<ApiResponse<List<Task>?>> getByProject(int projectId) async {
    final data = await client.get('/task/$projectId');
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      final jsonData = jsonDecode(data.data);
      return ApiResponse(
          data: (jsonData as List).map((e) => Task.fromJson(e)).toList(),
          isSuccess: true,
          message: null,
          statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: null, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }

  Future<ApiResponse<Task?>> create(Task item) async {
    final data = await client.post('/task/', data: item.toJson());
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      return ApiResponse(
          data: Task.fromJson(data.data),
          isSuccess: true,
          message: null,
          statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: null, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }

  Future<ApiResponse<bool>> edit(Task item) async {
    final data = await client.put('/task/', data: item.toJson());
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      return ApiResponse(data: true, isSuccess: true, message: null, statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: false, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }

  Future<ApiResponse<bool>> delete(int id) async {
    final data = await client.delete('/task/$id');
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      return ApiResponse(data: true, isSuccess: true, message: null, statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: false, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }
}
