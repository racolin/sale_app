import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sale_app/data/models/token_model.dart';
import 'package:sale_app/presentation/res/strings/values.dart';

import '../../exception/app_message.dart';
import '../models/response_model.dart';

class SecureStorage {
  static SecureStorage? _instance;

  factory SecureStorage() => _instance ??= SecureStorage._(
        const FlutterSecureStorage(),
      );

  SecureStorage._(this._storage);

  final FlutterSecureStorage _storage;
  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';
  TokenModel? _token;

  Future<ResponseModel<bool>> persistToken(TokenModel token) async {
    _token = token;

    try {
      await _storage.write(
        key: _accessTokenKey,
        value: token.accessToken,
      );
      await _storage.write(
        key: _refreshTokenKey,
        value: token.refreshToken,
      );
      return ResponseModel<bool>(
        type: ResponseModelType.success,
        data: true,
      );
    } on PlatformException catch (ex) {
      return ResponseModel<bool>(
        type: ResponseModelType.failure,
        message: AppMessage(
          title: txtErrorTitle,
          type: AppMessageType.failure,
          content: 'Có lỗi xảy ra khi lưu phiên đăng nhập',
          description: ex.message,
        ),
      );
    } on Exception catch (ex) {
      return ResponseModel<bool>(
        type: ResponseModelType.failure,
        message: AppMessage(
          type: AppMessageType.failure,
          title: txtUnknownErrorTitle,
          content: txtUnknownHandle,
          description: ex.toString(),
        ),
      );
    }
  }

  Future<ResponseModel<bool>> deleteToken() async {
    _token = null;
    try {
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
      return ResponseModel<bool>(
        type: ResponseModelType.success,
        data: true,
      );
    } on PlatformException catch (ex) {
      return ResponseModel<bool>(
        type: ResponseModelType.failure,
        message: AppMessage(
          title: txtErrorTitle,
          type: AppMessageType.error,
          content: 'Gặp sự cố khi xoá phiên đăng nhập.',
          description: ex.message,
        ),
      );
    } on Exception catch (ex) {
      return ResponseModel<bool>(
        type: ResponseModelType.failure,
        message: AppMessage(
          title: txtUnknownErrorTitle,
          type: AppMessageType.failure,
          content: txtUnknownHandle,
          description: ex.toString(),
        ),
      );
    }
  }

  Future<ResponseModel<TokenModel>> getToken() async {
    if (_token != null) {
      return ResponseModel<TokenModel>(
        type: ResponseModelType.success,
        data: _token!,
      );
    }

    var resAccess = await getAccessToken();
    if (resAccess.type == ResponseModelType.failure) {
      return ResponseModel(
        type: ResponseModelType.failure,
        message: resAccess.message,
      );
    }
    var resRefresh = await getRefreshToken();
    if (resRefresh.type == ResponseModelType.failure) {
      return ResponseModel(
        type: ResponseModelType.failure,
        message: resRefresh.message,
      );
    }

    return ResponseModel<TokenModel>(
      type: ResponseModelType.success,
      data: TokenModel(
        accessToken: resAccess.data,
        refreshToken: resRefresh.data,
      ),
    );
  }

  bool hasExpired(String token, int milliseconds) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    var exp = DateTime.fromMillisecondsSinceEpoch(
      decodedToken['exp'] * 1000 ?? 0,
    );
    var e = DateTime.now().add(
      Duration(milliseconds: milliseconds),
    );
    return exp.isAfter(e);
  }

  Future<ResponseModel<String>> getAccessToken() async {
    if (_token != null) {
      return ResponseModel<String>(
        type: ResponseModelType.success,
        data: _token!.accessToken,
      );
    }

    try {
      String? accessToken = await _storage.read(key: _accessTokenKey);
      if (accessToken != null) {
        return ResponseModel<String>(
          type: ResponseModelType.success,
          data: accessToken,
        );
      }
      return ResponseModel<String>(
        type: ResponseModelType.failure,
        message: AppMessage(
          type: AppMessageType.logout,
          title: txtFailureTitle,
          content: 'Bạn chưa đăng nhập. Hãy đăng nhập!',
        ),
      );
    } on PlatformException catch (ex) {
      return ResponseModel<String>(
        type: ResponseModelType.failure,
        message: AppMessage(
          type: AppMessageType.error,
          title: txtErrorTitle,
          content: 'Có lỗi xảy ra khi lấy phiên đăng nhập!\nHãy thử lại',
          description: ex.message,
        ),
      );
    } on Exception catch (ex) {
      return ResponseModel<String>(
        type: ResponseModelType.failure,
        message: AppMessage(
          title: txtUnknownErrorTitle,
          type: AppMessageType.failure,
          content: txtUnknownHandle,
          description: ex.toString(),
        ),
      );
    }
  }

  Future<ResponseModel<String>> getRefreshToken() async {
    if (_token != null) {
      return ResponseModel<String>(
        type: ResponseModelType.success,
        data: _token!.refreshToken,
      );
    }

    try {
      String? refreshToken = await _storage.read(key: _refreshTokenKey);
      if (refreshToken != null) {
        return ResponseModel<String>(
          type: ResponseModelType.success,
          data: refreshToken,
        );
      }

      return ResponseModel<String>(
        type: ResponseModelType.failure,
        message: AppMessage(
          type: AppMessageType.none,
          title: txtFailureTitle,
          content: 'Không thể làm mới phiên đăng nhập!',
        ),
      );
    } on PlatformException catch (ex) {
      return ResponseModel<String>(
        type: ResponseModelType.failure,
        message: AppMessage(
          type: AppMessageType.error,
          title: txtErrorTitle,
          content: 'Có lỗi xảy ra khi làm mới phiên đăng nhập!\nHãy thử lại',
          description: ex.message,
        ),
      );
    } on Exception catch (ex) {
      return ResponseModel<String>(
        type: ResponseModelType.failure,
        message: AppMessage(
          type: AppMessageType.failure,
          title: txtUnknownErrorTitle,
          content: txtUnknownHandle,
          description: ex.toString(),
        ),
      );
    }
  }

  Future<ResponseModel<bool>> deleteAll() async {
    _token = null;
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
          title: txtErrorTitle,
          type: AppMessageType.failure,
          content: 'Có vấn đề khi xoá dữ liệu để đăng xuất.\nHãy thử lại!',
          description: ex.message,
        ),
      );
    } catch (ex) {
      return ResponseModel<bool>(
        type: ResponseModelType.failure,
        message: AppMessage(
          title: txtUnknownErrorTitle,
          type: AppMessageType.failure,
          content: txtUnknownHandle,
          description: ex.toString(),
        ),
      );
    }
  }
}
