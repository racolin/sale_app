import '../../data/models/cart_model.dart';
import '../../data/models/cart_status_model.dart';
import '../../data/models/response_model.dart';

abstract class CartRepository {
  Future<ResponseModel<MapEntry<int, List<CartModel>>>> gets({
    required String statusId,
    int? page,
    int? limit,
  });

  Future<ResponseModel<List<CartStatusModel>>> getStatuses();

  Future<ResponseModel<bool>> updateStatus({
    required String id,
    required String status,
  });
}
