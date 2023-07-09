import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/data/models/cart_status_model.dart';
import 'package:sale_app/presentation/res/strings/values.dart';

import '../../data/models/paging_model.dart';
import 'package:sale_app/data/models/response_model.dart';
import '../../exception/app_message.dart';
import '../../data/models/cart_model.dart';
import '../repositories/cart_repository.dart';
import '../states/carts_state.dart';

class CartCubit extends Cubit<CartsState> {
  final CartRepository _repository;

  CartCubit({required CartRepository repository})
      : _repository = repository,
        super(CartsInitial()) {
    emit(CartsLoading());
    _repository.getStatuses().then((res) {
      if (res.type == ResponseModelType.success) {
        var statuses = res.data;
        if (statuses.isNotEmpty) {
          _repository
              .gets(statusId: statuses[0].id, page: 1, limit: 10)
              .then((res) {
            if (res.type == ResponseModelType.success) {
              Map<String, PagingModel<CartModel>> listCarts = {};
              for (var e in statuses) {
                listCarts[e.id] = PagingModel<CartModel>(
                  page: 1,
                  limit: 10,
                  list: [],
                );
              }
              listCarts[statuses[0].id]?.next(res.data.value, res.data.key);

              emit(
                CartsLoaded(
                  listCarts: listCarts,
                  statuses: statuses,
                ),
              );
            } else {
              emit(CartsFailure(message: res.message));
            }
          });
        } else {
          emit(
            CartsFailure(
              message: AppMessage(
                type: AppMessageType.failure,
                title: txtFailureTitle,
                content: 'Danh sách trạng thái rỗng. Hãy thử lại',
              ),
            ),
          );
        }
      } else {
        emit(CartsFailure(message: res.message));
      }
    });
  }

  Future<AppMessage?> loadMore(String id) async {
    if (this.state is! CartsLoaded) {
      return AppMessage(
        type: AppMessageType.failure,
        title: txtFailureTitle,
        content: txtToFast,
      );
    }
    var state = this.state as CartsLoaded;

    if (state.listCarts[id]?.hasNext() ?? false) {
      var res = await _repository.gets(
        statusId: id,
        page: state.listCarts[id]!.page,
        limit: state.listCarts[id]!.limit,
      );
      if (res.type == ResponseModelType.success) {
        state.listCarts[id]!.next(res.data.value, res.data.key);

        emit(state.copyWith(listCarts: state.listCarts));
        return null;
      } else {
        return res.message;
      }
    }
    return null;
  }

  String? getStatus(int i) {
    if (state is! CartsLoaded) {
      return null;
    }
    return (state as CartsLoaded).statuses[i].id;
  }

  List<CartStatusModel> getStatuses() {
    if (state is! CartsLoaded) {
      return [];
    }
    return (state as CartsLoaded).statuses;
  }

  Future<bool> updateStatus(String id, String status, String oldStatus) async {
    var res = await _repository.updateStatus(id: id, status: status);

    if (res.type == ResponseModelType.success) {
      if (state is CartsLoaded) {
        var state = this.state as CartsLoaded;
        var statuses = state.statuses;

        _repository
            .gets(statusId: oldStatus, page: 1, limit: 10)
            .then((res) {
          if (res.type == ResponseModelType.success) {
            Map<String, PagingModel<CartModel>> listCarts = {};
            for (var e in statuses) {
              listCarts[e.id] = PagingModel<CartModel>(
                page: 1,
                limit: 10,
                list: [],
              );
            }
            listCarts[oldStatus]?.next(res.data.value, res.data.key);

            emit(
              state.copyWith(listCarts: listCarts),
            );
          } else {
            emit(CartsFailure(message: res.message));
          }
        });
      }

      return res.data;
    }
    return false;
  }

  List<CartStatusModel> getStatusesExcept(String id) {
    if (state is! CartsLoaded) {
      return [];
    }
    return (state as CartsLoaded).statuses.where((e) => e.id != id).toList();
  }

  Future<void> refresh(int selected) async {
    if (state is CartsLoaded) {
      var state = this.state as CartsLoaded;
      var res = await _repository.gets(
        statusId: state.statuses[selected].id,
        page: 1,
        limit: 10,
      );

      if (res.type == ResponseModelType.success) {
        var list = state.listCarts;
        list[state.statuses[selected].id] = PagingModel<CartModel>(
          page: 1,
          limit: 10,
          list: [],
        );
        list[state.statuses[selected].id]?.next(res.data.value, res.data.key);
        emit(state.copyWith(listCarts: list));
      } else {}
    }
  }

  bool hasNext(String id) {
    if (state is CartsLoaded) {
      var state = this.state as CartsLoaded;
      return state.listCarts[id]?.hasNext() ?? false;
    }
    return false;
  }

  Future<AppMessage?> tap(String id) async {
    if (this.state is! CartsLoaded) {
      return AppMessage(
        type: AppMessageType.failure,
        title: txtFailureTitle,
        content: txtToFast,
      );
    }
    var state = this.state as CartsLoaded;
    var listCart = state.listCarts[id];
    if ((listCart?.list.isEmpty ?? false) && (listCart?.hasNext() ?? false)) {
      return loadMore(id);
    }
    return null;
  }
}
