import 'package:dio/dio.dart';
import 'package:sale_app/data/models/product_suggets_model.dart';

import '../../../presentation/res/strings/values.dart';
import '../../models/check_voucher_model.dart';
import '../../models/raw_failure_model.dart';
import '../../models/raw_success_model.dart';
import '../../models/voucher_model.dart';
import '../../services/api_client.dart';
import '../../models/product_category_model.dart';
import '../../models/product_model.dart';
import '../../models/product_option_model.dart';
import '../../../business_logic/repositories/product_repository.dart';
import '../../../exception/app_message.dart';
import '../../models/response_model.dart';
import '../../services/api_config.dart';

class ProductApiRepository extends ProductRepository {
  final _dioAuth = ApiClient.dioAuth;

  @override
  Future<ResponseModel<List<ProductCategoryModel>>> getCategories() async {
    try {
      var res = await _dioAuth.get(
        ApiRouter.productCategoryAll,
      );
      var raw = RawSuccessModel.fromMap(res.data);
      return ResponseModel<List<ProductCategoryModel>>(
        type: ResponseModelType.success,
        data: (raw.data as List)
            .map(
              (e) => ProductCategoryModel.fromMap(e),
            )
            .toList(),
      );
    } on DioError catch (ex) {
      if (ex.error is AppMessage) {
        return ResponseModel<List<ProductCategoryModel>>(
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
        return ResponseModel<List<ProductCategoryModel>>(
          type: ResponseModelType.failure,
          message: AppMessage(
            type: AppMessageType.error,
            title: raw.error ?? txtErrorTitle,
            content: raw.message ?? 'Không có dữ liệu trả về!',
          ),
        );
      }
    } on Exception catch (ex) {
      return ResponseModel<List<ProductCategoryModel>>(
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
  Future<ResponseModel<List<ProductOptionModel>>> getOptions() async {
    try {
      var res = await _dioAuth.get(
        ApiRouter.productOptionAll,
      );
      var raw = RawSuccessModel.fromMap(res.data);
      return ResponseModel<List<ProductOptionModel>>(
        type: ResponseModelType.success,
        data: (raw.data as List)
            .map(
              (e) => ProductOptionModel.fromMap(e),
            )
            .toList(),
      );
    } on DioError catch (ex) {
      if (ex.error is AppMessage) {
        return ResponseModel<List<ProductOptionModel>>(
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
        return ResponseModel<List<ProductOptionModel>>(
          type: ResponseModelType.failure,
          message: AppMessage(
            type: AppMessageType.error,
            title: raw.error ?? txtErrorTitle,
            content: raw.message ?? 'Không có dữ liệu trả về!',
          ),
        );
      }
    } on Exception catch (ex) {
      return ResponseModel<List<ProductOptionModel>>(
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
  Future<ResponseModel<List<ProductModel>>> gets({String? categoryId}) async {
    try {
      var res = await _dioAuth.get(
        ApiRouter.productAll(categoryId ?? 'all'),
      );
      var raw = RawSuccessModel.fromMap(res.data);
      return ResponseModel<List<ProductModel>>(
        type: ResponseModelType.success,
        data: (raw.data as List)
            .map(
              (e) => ProductModel.fromMap(e),
            )
            .toList(),
      );
    } on DioError catch (ex) {
      if (ex.error is AppMessage) {
        return ResponseModel<List<ProductModel>>(
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
        return ResponseModel<List<ProductModel>>(
          type: ResponseModelType.failure,
          message: AppMessage(
            type: AppMessageType.error,
            title: raw.error ?? txtErrorTitle,
            content: raw.message ?? 'Không có dữ liệu trả về!',
          ),
        );
      }
    } on Exception catch (ex) {
      return ResponseModel<List<ProductModel>>(
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
  Future<ResponseModel<List<CheckVoucherModel>>> checkVoucher({
    String? userId,
    required String voucherId,
    required List<ProductSuggestModel> products,
  }) async {
    try {
      var res = await _dioAuth.post(
        ApiRouter.checkVoucher,
        data: {
          "userId": userId,
          "voucherId": voucherId,
          "products": products.map((e) => e.toMap()).toList(),
        },
      );
      var raw = RawSuccessModel.fromMap(res.data);
      return ResponseModel<List<CheckVoucherModel>>(
        type: ResponseModelType.success,
        data: (raw.data is List)
            ? (raw.data as List)
                .map((e) => CheckVoucherModel.fromMap(e))
                .toList()
            : [],
      );
    } on DioError catch (ex) {
      if (ex.error is AppMessage) {
        return ResponseModel<List<CheckVoucherModel>>(
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
        return ResponseModel<List<CheckVoucherModel>>(
          type: ResponseModelType.failure,
          message: AppMessage(
            type: AppMessageType.error,
            title: raw.error ?? txtErrorTitle,
            content: raw.message ?? 'Không có dữ liệu trả về!',
          ),
        );
      }
    } on Exception catch (ex) {
      return ResponseModel<List<CheckVoucherModel>>(
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
  Future<ResponseModel<List<VoucherModel>>> getAvailableVoucher({
    String? userId,
  }) async {
    try {
      var res = await _dioAuth.get(
        ApiRouter.getAvailableVoucher,
        queryParameters: {
          "userId": userId,
        },
      );
      var raw = RawSuccessModel.fromMap(res.data);
      return ResponseModel<List<VoucherModel>>(
        type: ResponseModelType.success,
        data: (raw.data is List)
            ? (raw.data as List).map((e) => VoucherModel.fromMap(e)).toList()
            : [],
      );
    } on DioError catch (ex) {
      if (ex.error is AppMessage) {
        return ResponseModel<List<VoucherModel>>(
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
        return ResponseModel<List<VoucherModel>>(
          type: ResponseModelType.failure,
          message: AppMessage(
            type: AppMessageType.error,
            title: raw.error ?? txtErrorTitle,
            content: raw.message ?? 'Không có dữ liệu trả về!',
          ),
        );
      }
    } on Exception catch (ex) {
      return ResponseModel<List<VoucherModel>>(
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
  Future<ResponseModel<List<CheckVoucherModel>>> getSuggestVoucher({
    String? userId,
    required List<ProductSuggestModel> products,
  }) async {
    try {
      var res = await _dioAuth.post(
        ApiRouter.suggestVoucher,
        data: {
          "userId": userId,
          "products": products.map((e) => e.toMap()).toList(),
        },
      );
      var raw = RawSuccessModel.fromMap(res.data);
      return ResponseModel<List<CheckVoucherModel>>(
        type: ResponseModelType.success,
        data: (raw.data is List)
            ? (raw.data as List)
                .map((e) => CheckVoucherModel.fromMap(e))
                .toList()
            : [],
      );
    } on DioError catch (ex) {
      if (ex.error is AppMessage) {
        return ResponseModel<List<CheckVoucherModel>>(
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
        return ResponseModel<List<CheckVoucherModel>>(
          type: ResponseModelType.failure,
          message: AppMessage(
            type: AppMessageType.error,
            title: raw.error ?? txtErrorTitle,
            content: raw.message ?? 'Không có dữ liệu trả về!',
          ),
        );
      }
    } on Exception catch (ex) {
      return ResponseModel<List<CheckVoucherModel>>(
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
