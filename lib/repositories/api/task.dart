part of 'api.dart';

extension TaskApiExt on ApiRepository {
  Task _convertDescriptionForBack(Task item) {
    return item.copyWith(
        description: item.description
            .replaceAll(r'\n', r'\\n')
            .replaceAll(r'\"', r'\\"')
            .replaceAll(r"'", r"\'"));
  }

  Task _convertDescriptionFromBack(Task item) {
    return item.copyWith(
        description: item.description
            .replaceAll(r'\\n', r'\n')
            .replaceAll(r'\\"', r'\"')
            .replaceAll(r"\'", r"'"));
  }

  Future<ApiResponse<Task?>> getTaskById(int id) async {
    return ApiErrorHandler(() async {
      final data = await client.get('/task/$id');
      return ApiResponse(
          body: _convertDescriptionFromBack(Task.fromJson(data.data!)), status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<List<Task>?>> getTasksAll() async {
    return ApiErrorHandler(() async {
      final data = await client.get('/task');
      return ApiResponse(
        body:
            (data.data as List).map((e) => _convertDescriptionFromBack(Task.fromJson(e))).toList(),
        status: data.statusCode!,
      );
    }).result;
  }

  Future<ApiResponse<List<Task>?>> getTasksByProject(int projectId) async {
    return ApiErrorHandler(() async {
      final data = await client.get('/task/project/$projectId');

      return ApiResponse(
        body:
            (data.data as List).map((e) => _convertDescriptionFromBack(Task.fromJson(e))).toList(),
        status: data.statusCode!,
      );
    }).result;
  }

  Future<ApiResponse<Task?>> createTask(Task item) async {
    return ApiErrorHandler(() async {
      final data = await client.post('/task', data: _convertDescriptionForBack(item).toJson());
      return ApiResponse(body: Task.fromJson(data.data), status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<bool?>> editTask(Task item) async {
    return ApiErrorHandler(() async {
      final data = await client.put('/task', data: _convertDescriptionForBack(item).toJson());
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
