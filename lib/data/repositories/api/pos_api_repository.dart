import 'package:dio/dio.dart';

import '../../../business_logic/repositories/pos_repository.dart';
import '../../../presentation/res/strings/values.dart';
import '../../../exception/app_message.dart';
import '../../models/pos_model.dart';
import '../../models/raw_failure_model.dart';
import '../../models/raw_success_model.dart';
import '../../models/response_model.dart';
import '../../services/api_client.dart';
import '../../services/api_config.dart';

class PosApiRepository extends PosRepository {
  final _dio = ApiClient.dioAuth;

  @override
  Future<ResponseModel<String>> createCart({
    String? memberCode,
    String? voucherId,
    required int payType,
    required List<PosProductModel> products,
  }) async {
    try {
      var res = await _dio.post(
        ApiRouter.cartCreate,
        data: {
          'memberCode': memberCode,
          if (voucherId != null )'voucherId': voucherId,
          'payType': payType,
          'products': products
              .map(
                (e) => e.toMap(),
              )
              .toList(),
        },
      );
      var raw = RawSuccessModel.fromMap(res.data);
      return ResponseModel<String>(
        type: ResponseModelType.success,
        data: raw.data["_id"],
      );
    } on DioError catch (ex) {
      if (ex.error is AppMessage) {
        return ResponseModel<String>(
          type: ResponseModelType.failure,
          message: ex.error,
        );
      } else {
        var raw = RawFailureModel.fromMap(
          ex.response?.data ??
              {
                'statusCode': 444,
                'message': 'Không có dữ liệu trả về!',
              },
        );
        return ResponseModel<String>(
          type: ResponseModelType.failure,
          message: AppMessage(
            type: AppMessageType.error,
            title: raw.error ?? txtErrorTitle,
            content: raw.message ?? 'Không có dữ liệu trả về!',
          ),
        );
      }
    } on Exception catch (ex) {
      return ResponseModel<String>(
        type: ResponseModelType.failure,
        message: AppMessage(
          title: txtErrorTitle,
          type: AppMessageType.error,
          content: 'Chưa phân tích được lỗi',
          description: ex.toString(),
        ),
      );
    }
  }
}
