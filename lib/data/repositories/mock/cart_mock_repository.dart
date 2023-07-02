import 'dart:math';

import '../../../business_logic/repositories/cart_repository.dart';
import '../../models/cart_model.dart';
import '../../../exception/app_message.dart';
import '../../models/cart_status_model.dart';
import '../../models/response_model.dart';

class CartMockRepository extends CartRepository {

  @override
  Future<ResponseModel<List<CartStatusModel>>> getStatuses() async {
    return ResponseModel<List<CartStatusModel>>(
      type: ResponseModelType.success,
      data: [
        const CartStatusModel(id: 'STT-01', name: 'Đang thực hiện'),
        const CartStatusModel(id: 'STT-02', name: 'Đã hoàn tất'),
        const CartStatusModel(id: 'STT-03', name: 'Đã huỷ'),
      ],
      // data: false,
    );
    return ResponseModel<List<CartStatusModel>>(
      type: ResponseModelType.failure,
      message: AppMessage(
        type: AppMessageType.error,
        title: 'Có lỗi!',
        content: 'Gặp sự cố khi lấy danh sách trạng thái đơn hàng',
      ),
    );
  }

  @override
  Future<ResponseModel<MapEntry<int, List<CartModel>>>> gets({
    required String statusId,
    int? page,
    int? limit,
  }) async {
    return ResponseModel<MapEntry<int, List<CartModel>>>(
      type: ResponseModelType.success,
      data: statusId == 'STT-01'
          ? const MapEntry(0, [])
          : MapEntry(
              43,
              List.generate(
                20,
                (index) => CartModel(
                  id: 'CART-01',
                  name: 'Đường Đen Marble Latte, '
                      'Hi-Tea Yuzu Trần Châu +2 sản phẩm khác',
                  cost: 114000,
                  rate: Random().nextInt(5),
                  payType: 0,
                  categoryId: DeliveryType.takeOut,
                  time: DateTime.now(),
                  products: [
                    const CartProductModel(
                      id: 'cp1',
                      name: 'C P 1',
                      cost: 10000,
                      options: ['OPTION-1-2', 'OPTION-2-1'],
                      amount: 2,
                      note: '',
                    ),
                    const CartProductModel(
                      id: 'cp2',
                      name: 'C P 2',
                      cost: 20000,
                      options: ['OPTION-3-2', 'OPTION-4-1'],
                      amount: 1,
                      note: '',
                    ),
                  ],
                ),
              ),
            ),
      // data: false,
    );
    return ResponseModel<MapEntry<int, List<CartModel>>>(
      type: ResponseModelType.failure,
      message: AppMessage(
        type: AppMessageType.error,
        title: 'Có lỗi!',
        content: 'Gặp sự cố khi lấy danh sách đơn hàng theo trạng thái',
      ),
    );
  }
}
