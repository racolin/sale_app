import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:sale_app/data/models/raw_failure_model.dart';
import 'package:sale_app/data/models/raw_success_model.dart';
import 'package:sale_app/data/models/response_model.dart';
import 'package:sale_app/data/services/api_client.dart';
import 'package:sale_app/data/services/api_config.dart';

import '../../../business_logic/repositories/auth_repository.dart';
import '../../../exception/app_message.dart';
import '../../../presentation/res/strings/values.dart';
import '../../services/secure_storage.dart';

class AuthApiRepository extends AuthRepository {
  final _dio = ApiClient.dioNoAuth;
  final _storage = SecureStorage();

  @override
  Future<ResponseModel<bool>> login({
    required String username,
    required String password,
  }) async {
    try {
      var res = await _dio.post(
        ApiRouter.authLogin,
        data: {
          'username': username,
          'password': password,
        },
      );
      var raw = RawSuccessModel.fromMap(res.data);
      return ResponseModel<bool>(
        type: ResponseModelType.success,
        data: raw.success ?? false,
      );
    } on DioError catch (ex) {
      if (ex.error is AppMessage) {
        return ResponseModel<bool>(
          type: ResponseModelType.failure,
          message: ex.error,
        );
      } else {
        var raw = RawFailureModel.fromMap(
          ex.response?.data ??
              {
                'statusCode': 444,
                'message': 'Không có dữ liệu trả về!',
              },
        );
        return ResponseModel<bool>(
          type: ResponseModelType.failure,
          message: AppMessage(
            type: AppMessageType.error,
            title: raw.error ?? txtErrorTitle,
            content: raw.message ?? 'Không có dữ liệu trả về!',
          ),
        );
      }
    } on Exception catch (ex) {
      return ResponseModel<bool>(
        type: ResponseModelType.failure,
        message: AppMessage(
          title: txtErrorTitle,
          type: AppMessageType.error,
          content: 'Chưa phân tích được lỗi',
          description: ex.toString(),
        ),
      );
    }
  }

  @override
  Future<ResponseModel<bool>> logout() async {
    try {
      await _storage.deleteAll();
      return ResponseModel<bool>(
        type: ResponseModelType.success,
        data: true,
      );
    } on PlatformException catch (ex) {
      return ResponseModel<bool>(
        type: ResponseModelType.failure,
        message: AppMessage(
          type: AppMessageType.failure,
          title: 'Có lỗi',
          content: 'Quá trình đăng xuất gặp vấn đề. Hãy thử lại!',
          description: ex.toString(),
        ),
      );
    }
  }

  @override
  Future<ResponseModel<bool>> isLogin() async {
    try {
      var res = await _storage.getToken();
      if (res.type == ResponseModelType.success) {
        return ResponseModel<bool>(
          type: ResponseModelType.success,
          data: true,
        );
      } else {
        return ResponseModel<bool>(
          type: ResponseModelType.success,
          data: false,
        );
      }
    } on PlatformException catch (ex) {
      return ResponseModel<bool>(
        type: ResponseModelType.failure,
        message: AppMessage(
          type: AppMessageType.error,
          title: txtErrorTitle,
          content: 'Lỗi khi kiểm tra trạng thái đăng nhập',
          description: ex.toString(),
        ),
      );
    }
  }
}
