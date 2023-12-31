import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/data/models/pos_model.dart';
import 'package:sale_app/data/models/response_model.dart';
import 'package:sale_app/exception/app_message.dart';

import '../repositories/pos_repository.dart';
import '../states/pos_state.dart';

class PosCubit extends Cubit<PosState> {
  final PosRepository _repository;

  PosCubit({required PosRepository repository})
      : _repository = repository,
        super(PosState(
          listPos: [],
          employees: [],
        )) {
    _repository.getEmployees().then((res) {
      if (res.type == ResponseModelType.success) {
        emit(state.copyWith(employees: res.data));
      }
    });
  }

  void setEmployee(String id) {
    print(id);
    emit(state.copyWith(employeeId: id));
  }

  bool isSelected(String id) => state.isSelected(id);

  bool addProduct(PosProductModel model) {
    print(model.toMap());
    print('model.toMap()');
    if (state.index != null &&
        state.index! >= 0 &&
        state.index! < state.listPos.length) {
      var list = state.listPos;
      var cur = state.currentPos!;
      var i = cur.products.indexOf(model);
      if (i == -1) {
        print(cur.username);
        print(cur.memberCode);
        cur = cur.copyWith(products: cur.products + [model]);
        print(cur.username);
        print(cur.memberCode);
        print('cur.memberCode');
      } else {
        cur = cur.copyWith(
            products: cur.products.sublist(0, i) +
                [
                  cur.products[i].copyWith(
                    amount: cur.products[i].amount + model.amount,
                  )
                ] +
                cur.products.sublist(i + 1, cur.products.length));
      }
      var newList = list.sublist(0, state.index) +
          [cur] +
          list.sublist(state.index! + 1, state.listPos.length);
      emit(state.copyWith(listPos: newList));
      return true;
    }
    return false;
  }

  bool removeProduct(int index) {
    if (state.index != null &&
        state.index! >= 0 &&
        state.index! < state.listPos.length) {
      var list = state.listPos;
      var cur = state.currentPos!;
      cur = cur.copyWith(
        products: cur.products.sublist(0, index) +
            cur.products.sublist(index + 1, cur.products.length),
      );
      var newList = list.sublist(0, state.index) +
          [cur] +
          list.sublist(state.index! + 1, state.listPos.length);
      emit(state.copyWith(listPos: newList));
      return true;
    }
    return false;
  }

  Future<bool> createCart() async {
    var i = state.index;
    if (i != null && i < state.listPos.length) {
      var pos = state.listPos[i];
      if (pos.isNotEmpty()) {
        var res = await _repository.createCart(
          memberCode: pos.memberCode,
          payType: pos.payType,
          products: pos.products,
          voucherId: pos.voucherId,
          employeeId: state.employeeId,
        );

        if (res.type == ResponseModelType.success) {
          return true;
        }
      } else {
        emit(
          state.copyWith(
            message: AppMessage(
              type: AppMessageType.error,
              title: 'Chưa đủ thông tin',
              content: 'Không thể tạo đơn hàng vì chưa có đầy đủ thông tin!',
            ),
          ),
        );
      }
    }
    return false;
  }

  List<PosModel> get list => state.listPos;

  List<String> get names => state.names;

  void addNewTab([String? name, String? code]) {
    if (name == null || name.isEmpty) {
      name = 'Vãng lai';
    }
    var i = names.length;
    emit(
      state.copyWith(
        listPos: state.listPos +
            [
              PosModel(
                memberCode: code,
                username: name,
              ),
            ],
        index: i,
      ),
    );
    print(state.listPos.map((e) => e.toMap()));
  }

  void setIndex(int i) {
    if (i >= 0 && i < list.length) {
      emit(state.copyWith(index: i));
    }
  }

  void removeCurrentTab() {
    if (state.index != null) {
      removeTab(state.index!);
    }
  }

  void removeTab(int i) {
    int? index = i;
    if (i < state.listPos.length) {
      var list = [...state.listPos];
      list.removeAt(i);
      if (list.isEmpty) {
        index = null;
      } else if (i >= list.length) {
        i = list.length - 1;
        index = i >= 0 ? i : 0;
      }
      emit(PosState(listPos: list, index: index, employees: state.employees));
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
