import '../../data/models/cart_model.dart';
import '../../data/models/cart_status_model.dart';
import '../../data/models/response_model.dart';

abstract class CartRepository {
  Future<ResponseModel<MapEntry<int, List<CartModel>>>> gets({
    required String statusId,
    int? page,
    int? limit,
  });

  ///
  /// 0: mọi lúc, 1: trong ngày, 2: trong tuần, 3: trong tháng
  ///
  Future<ResponseModel<List<CartStatusModel>>> getStatuses({
    int? page,
    int? limit,
    int? time,
  });

  Future<ResponseModel<bool>> updateStatus({
    required String id,
    String? employeeId,
    required String status,
  });
}
