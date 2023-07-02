import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/data/models/pos_model.dart';
import 'package:sale_app/exception/app_message.dart';

import '../repositories/pos_repository.dart';
import '../states/pos_state.dart';

class PosCubit extends Cubit<PosState> {
  final PosRepository _repository;

  PosCubit({required PosRepository repository})
      : _repository = repository,
        super(PosState(
          listPos: [],
        ));

  Future createCart(int i) async {
    if (i < state.listPos.length) {
      var pos = state.listPos[i];
      if (pos.isEmpty()) {
        _repository.createCart(
          memberCode: pos.memberCode,
          payType: pos.payType!,
          products: pos.products!,
          voucherId: pos.voucherId,
        );
      } else {
        emit(
          state.copyWith(
            message: AppMessage(
              type: AppMessageType.error,
              title: 'Chưa đủ thông tin',
              content: 'Không thể tạo đơn hàng vì chưa có đầu đủ thông tin!',
            ),
          ),
        );
      }
    }
  }

  void addNewTab() {
    emit(state.copyWith(listPos: state.listPos + [const PosModel()]));
  }

  void removeTab(int i) {
    if (i < state.listPos.length) {
      var list = [...state.listPos];
      list.removeAt(i);
      emit(PosState(listPos: list));
    } else {
      emit(
        state.copyWith(
          message: AppMessage(
            type: AppMessageType.error,
            title: 'Không xác định',
            content: 'Tab hiện tại không khả dụng, vui lòng thử lại!',
          ),
        ),
      );
    }
  }
}
