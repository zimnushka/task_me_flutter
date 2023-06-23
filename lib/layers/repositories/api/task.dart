// ignore_for_file: unnecessary_lambdas
import 'package:task_me_flutter/layers/models/api_response.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/api.dart';

class TaskApiRepository extends ApiRepository {
  Future<ApiResponse<Task?>> getById(int id) async {
    return ApiErrorHandler(() async {
      final data = await client.get('/task/$id');
      return ApiResponse(body: Task.fromJson(data.data!), status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<List<Task>?>> getAll() async {
    return ApiErrorHandler(() async {
      final data = await client.get('/task');
      return ApiResponse(
        body: (data.data as List).map((e) => Task.fromJson(e)).toList(),
        status: data.statusCode!,
      );
    }).result;
  }

  Future<ApiResponse<List<Task>?>> getByProject(int projectId) async {
    return ApiErrorHandler(() async {
      final data = await client.get('/task/project/$projectId');

      return ApiResponse(
        body: (data.data as List).map((e) => Task.fromJson(e)).toList(),
        status: data.statusCode!,
      );
    }).result;
  }

  Future<ApiResponse<Task?>> create(Task item) async {
    return ApiErrorHandler(() async {
      final data = await client.post('/task', data: item.toJson());
      return ApiResponse(body: Task.fromJson(data.data), status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<bool?>> edit(Task item) async {
    return ApiErrorHandler(() async {
      final data = await client.put('/task', data: item.toJson());
      return ApiResponse(body: true, status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<bool?>> delete(int id) async {
    return ApiErrorHandler(() async {
      final data = await client.delete('/task/$id');
      return ApiResponse(body: true, status: data.statusCode!);
    }).result;
  }
}
