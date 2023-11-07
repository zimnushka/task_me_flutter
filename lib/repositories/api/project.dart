part of 'api.dart';

extension ProjectApiExt on ApiRepository {
  Future<ApiResponse<List<Project>?>> getProjectsAll() {
    return ApiErrorHandler(() async {
      final data = await client.get('/project');
      final jsonData = data.data;
      return ApiResponse(
          // ignore: unnecessary_lambdas
          body: (jsonData as List).map((e) => Project.fromJson(e)).toList(),
          status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<Project?>> getProjectById(int id) async {
    return ApiErrorHandler(() async {
      final data = await client.get('/project/$id');
      return ApiResponse(
        body: Project.fromJson(data.data),
        status: data.statusCode!,
      );
    }).result;
  }

  Future<ApiResponse<bool?>> addProject(Project project) async {
    return ApiErrorHandler(() async {
      final data = await client.post('/project', data: project.toJson());
      return ApiResponse(body: true, status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<bool?>> editProject(Project item) async {
    return ApiErrorHandler(() async {
      final data = await client.put('/project', data: item.toJson());
      return ApiResponse(body: true, status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<bool?>> deleteProject(int id) async {
    return ApiErrorHandler(() async {
      final data = await client.delete('/project/$id');
      return ApiResponse(body: true, status: data.statusCode!);
    }).result;
  }
}
