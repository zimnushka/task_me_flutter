part of 'api.dart';

extension TaskApiExt on ApiRepository {
  Future<ApiResponse<Task?>> getTaskById(int id) async {
    return ApiErrorHandler(() async {
      final data = await client.get('/task/$id');
      return ApiResponse(body: Task.fromJson(data.data!), status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<List<Task>?>> getTasksAll() async {
    return ApiErrorHandler(() async {
      final data = await client.get('/task');
      return ApiResponse(
        body: (data.data as List).map((e) => Task.fromJson(e)).toList(),
        status: data.statusCode!,
      );
    }).result;
  }

  Future<ApiResponse<List<Task>?>> getTasksByProject(int projectId) async {
    return ApiErrorHandler(() async {
      final data = await client.get('/task/project/$projectId');

      return ApiResponse(
        body: (data.data as List).map((e) => Task.fromJson(e)).toList(),
        status: data.statusCode!,
      );
    }).result;
  }

  Future<ApiResponse<Task?>> createTask(Task item) async {
    return ApiErrorHandler(() async {
      final data = await client.post('/task', data: item.toJson());
      return ApiResponse(body: Task.fromJson(data.data), status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<bool?>> editTask(Task item) async {
    return ApiErrorHandler(() async {
      final data = await client.put('/task', data: item.toJson());
      return ApiResponse(body: true, status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<bool?>> deleteTask(int id) async {
    return ApiErrorHandler(() async {
      final data = await client.delete('/task/$id');
      return ApiResponse(body: true, status: data.statusCode!);
    }).result;
  }
}
