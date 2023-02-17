// ignore_for_file: unnecessary_lambdas

import 'dart:convert';
import 'package:task_me_flutter/layers/models/api_response.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/api.dart';

class IntervalApiRepository extends ApiRepository {
  Future<ApiResponse<List<TimeInterval>?>> getMyIntervals() async {
    return ApiErrorHandler(() async {
      final data = await client.get('/timeIntervals/');
      final jsonData = jsonDecode(data.data);
      return ApiResponse(
        body: (jsonData as List).map((e) => TimeInterval.fromJson(e)).toList(),
        status: data.statusCode!,
      );
    }).result;
  }

  Future<ApiResponse<List<TimeInterval>?>> getTaskIntervals(int id) async {
    return ApiErrorHandler(() async {
      final data = await client.get('/timeIntervals/$id');
      final jsonData = jsonDecode(data.data);
      return ApiResponse(
        body: (jsonData as List).map((e) => TimeInterval.fromJson(e)).toList(),
        status: data.statusCode!,
      );
    }).result;
  }

  Future<ApiResponse<TimeInterval?>> start(int id) async {
    return ApiErrorHandler(() async {
      final data = await client.post('/timeIntervals/$id');
      return ApiResponse(
          body: TimeInterval.fromJson(jsonDecode(data.data)), status: data.statusCode!);
    }).result;
  }

  Future<ApiResponse<bool?>> stop(int id) async {
    return ApiErrorHandler(() async {
      final data = await client.put('/timeIntervals/$id');
      return ApiResponse(body: true, status: data.statusCode!);
    }).result;
  }
}
