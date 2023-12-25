import 'dart:math';

import 'package:sale_app/data/models/employee_model.dart';

import '../../../business_logic/repositories/cart_repository.dart';
import '../../../business_logic/repositories/pos_repository.dart';
import '../../models/cart_model.dart';
import '../../../exception/app_message.dart';
import '../../models/cart_status_model.dart';
import '../../models/pos_model.dart';
import '../../models/response_model.dart';

class PosMockRepository extends PosRepository {
  @override
  Future<ResponseModel<String>> createCart({
    String? memberCode,
    String? voucherId,
    String? employeeId,
    required int payType,
    required List<PosProductModel> products,
  }) async {
    return ResponseModel<String>(
      type: ResponseModelType.success,
      data: 'CART-11',
      // data: false,
    );
    return ResponseModel<String>(
      type: ResponseModelType.failure,
      message: AppMessage(
        type: AppMessageType.error,
        title: 'Có lỗi!',
        content: 'Gặp sự cố khi tạo đơn hàng',
      ),
    );
  }

  @override
  Future<ResponseModel<List<EmployeeModel>>> getEmployees() {
    // TODO: implement getEmployees
    throw UnimplementedError();
  }
}
