import 'package:task_me_flutter/domain/models/api_response.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/repositories/api/api.dart';

class ProjectApiRepository extends ApiRepository {
  Future<ApiResponse<List<Project>?>> getAll() {
    return ApiErrorHandler(() async {
      final data = await client.get('/project');
      final jsonData = data.data;
      return ApiResponse(
          // ignore: unnecessary_lambdas
          body: (jsonData as List).map((e) => Project.fromJson(e)).toList(),
          status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<Project?>> getById(int id) async {
    return ApiErrorHandler(() async {
      final data = await client.get('/project/$id');
      return ApiResponse(
        body: Project.fromJson(data.data),
        status: data.statusCode!,
      );
    }).result;
  }

  Future<ApiResponse<bool?>> add(Project project) async {
    return ApiErrorHandler(() async {
      final data = await client.post('/project', data: project.toJson());
      return ApiResponse(body: true, status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<bool?>> edit(Project item) async {
    return ApiErrorHandler(() async {
      final data = await client.put('/project', data: item.toJson());
      return ApiResponse(body: true, status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<bool?>> delete(int id) async {
    return ApiErrorHandler(() async {
      final data = await client.delete('/project/$id');
      return ApiResponse(body: true, status: data.statusCode!);
    }).result;
  }
}
