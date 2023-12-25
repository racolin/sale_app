import 'package:sale_app/data/models/employee_model.dart';

import '../../data/models/pos_model.dart';
import '../../data/models/response_model.dart';

abstract class PosRepository {
  Future<ResponseModel<String>> createCart({
    String? memberCode,
    String? employeeId,
    String? voucherId,
    required int payType,
    required List<PosProductModel> products,
  });

  Future<ResponseModel<List<EmployeeModel>>> getEmployees();
}
