import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/response_model.dart';
import '../../exception/app_message.dart';
import '../../presentation/res/strings/values.dart';
import '../repositories/auth_repository.dart';
import '../states/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit({required AuthRepository repository})
      : _repository = repository,
        super(AuthInitial()) {
    _repository.isLogin().then((r) {
      if (r.type == ResponseModelType.success && r.data) {
        emit(AuthLogin());
      } else {
        emit(AuthNoLogin());
      }
    });
  }

  // base method: return response model, use to avoid repeat code.

  // action method, change state and return AppMessage?, null when success

  Future<AppMessage?> login(String username, String password) async {
    var res = await _repository.login(username: username, password: password);
    if (res.type == ResponseModelType.success) {
      if (res.data) {
        emit(AuthLogin());
        return null;
      } else {
        return AppMessage(
          type: AppMessageType.error,
          title: txtFailureTitle,
          content: 'Thông tin đăng nhập không chính xác!',
        );
      }
    } else {
      return res.message;
    }
  }

  // Action data
  Future<AppMessage?> logout() async {
    var res = await _repository.logout();
    if (res.type == ResponseModelType.success) {
      return null;
    }
    return res.message;
  }
}
