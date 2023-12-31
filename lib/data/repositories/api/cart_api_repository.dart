import 'package:dio/dio.dart';

import '../../../business_logic/repositories/cart_repository.dart';
import '../../../presentation/res/strings/values.dart';
import '../../models/cart_model.dart';
import '../../../exception/app_message.dart';
import '../../models/cart_status_model.dart';
import '../../models/raw_failure_model.dart';
import '../../models/raw_success_model.dart';
import '../../models/response_model.dart';
import '../../services/api_client.dart';
import '../../services/api_config.dart';

class CartApiRepository extends CartRepository {
  final _dio = ApiClient.dioAuth;

  @override
  Future<ResponseModel<List<CartStatusModel>>> getStatuses({
    int? page,
    int? limit,
    int? time,
  }) async {
    try {
      var res = await _dio.get(
        ApiRouter.cartStatus,
        queryParameters: {
          'page': page,
          'limit': limit,
          'time': time,
        },
      );
      var raw = RawSuccessModel.fromMap(res.data);
      return ResponseModel<List<CartStatusModel>>(
        type: ResponseModelType.success,
        data: (raw.data as List).map(
              (e) => CartStatusModel.fromMap(e),
        ).toList(),
      );
    } on DioError catch (ex) {
      if (ex.error is AppMessage) {
        return ResponseModel<List<CartStatusModel>>(
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
        return ResponseModel<List<CartStatusModel>>(
          type: ResponseModelType.failure,
          message: AppMessage(
            type: AppMessageType.error,
            title: raw.error ?? txtErrorTitle,
            content: raw.message ?? 'Không có dữ liệu trả về!',
          ),
        );
      }
    } on Exception catch (ex) {
      return ResponseModel<List<CartStatusModel>>(
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

  @override
  Future<ResponseModel<MapEntry<int, List<CartModel>>>> gets({
    required String statusId,
    int? page,
    int? limit,
  }) async {
    try {
      var res = await _dio.get(
        ApiRouter.cartsByState(statusId),
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      var raw = RawSuccessModel.fromMap(res.data);

      return ResponseModel<MapEntry<int, List<CartModel>>>(
        type: ResponseModelType.success,
        data: MapEntry<int, List<CartModel>>(
          raw.data['maxCount'] ?? 0,
          (raw.data['carts'] as List)
              .map((e) => CartModel.fromMap(e))
              .toList(),
        ),
      );
    } on DioError catch (ex) {
      if (ex.error is AppMessage) {
        return ResponseModel<MapEntry<int, List<CartModel>>>(
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
        return ResponseModel<MapEntry<int, List<CartModel>>>(
          type: ResponseModelType.failure,
          message: AppMessage(
            type: AppMessageType.error,
            title: raw.error ?? txtErrorTitle,
            content: raw.message ?? 'Không có dữ liệu trả về!',
          ),
        );
      }
    } on Exception catch (ex) {
      return ResponseModel<MapEntry<int, List<CartModel>>>(
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

  @override
  Future<ResponseModel<bool>> updateStatus({
    required String id,
    required String status,
    String? employeeId,
  }) async {

    try {
      var res = await _dio.patch(
        ApiRouter.cartEditStatus,
        data: {
          'id': id,
          'status': status,
          'employeeId': employeeId,
        },
      );
      var raw = RawSuccessModel.fromMap(res.data);

      return ResponseModel<bool>(
        type: ResponseModelType.success,
        data: raw.success ?? false,
      );
    } on DioError catch (ex) {
      if (ex.error is AppMessage) {
        return ResponseModel<bool>(
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
        return ResponseModel<bool>(
          type: ResponseModelType.failure,
          message: AppMessage(
            type: AppMessageType.error,
            title: raw.error ?? txtErrorTitle,
            content: raw.message ?? 'Không có dữ liệu trả về!',
          ),
        );
      }
    } on Exception catch (ex) {
      return ResponseModel<bool>(
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
