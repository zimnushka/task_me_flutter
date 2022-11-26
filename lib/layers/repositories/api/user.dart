import 'dart:convert';

import 'package:task_me_flutter/layers/models/api_response.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/api/api.dart';

class UserApiRepository extends ApiRepository {
  Future<ApiResponse<User?>> getUserMe() async {
    final data = await client.get('/user/me');
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      return ApiResponse(
          data: User.fromJson(jsonDecode(data.data as String)),
          isSuccess: true,
          message: null,
          statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: null, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }
}
