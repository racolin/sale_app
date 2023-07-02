import 'package:sale_app/data/models/response_model.dart';

import '../../../business_logic/repositories/auth_repository.dart';
import '../../../exception/app_message.dart';

class AuthMockRepository extends AuthRepository {
  @override
  Future<ResponseModel<bool>> login({
    required String username,
    required String password,
  }) async {
    return ResponseModel<bool>(
      type: ResponseModelType.success,
      data: true,
      // data: false,
    );
    return ResponseModel<bool>(
      type: ResponseModelType.failure,
      message: AppMessage(
        type: AppMessageType.error,
        title: 'Có lỗi!',
        content: 'Chưa đăng nhập được. Hãy thử lại!',
      ),
    );
  }

  @override
  Future<ResponseModel<bool>> logout() async {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel<bool>> isLogin() async {
    throw UnimplementedError();
  }
}
