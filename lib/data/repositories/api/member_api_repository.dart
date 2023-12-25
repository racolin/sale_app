import 'package:dio/dio.dart';

import '../../../presentation/res/strings/values.dart';
import '../../models/member_model.dart';
import '../../models/raw_failure_model.dart';
import '../../models/raw_success_model.dart';
import '../../services/api_client.dart';
import '../../../business_logic/repositories/member_repository.dart';
import '../../../exception/app_message.dart';
import '../../models/response_model.dart';
import '../../services/api_config.dart';

class MemberApiRepository extends MemberRepository {
  final _dioAuth = ApiClient.dioAuth;
  @override
  Future<ResponseModel<MemberModel>> getMember() {
    // TODO: implement searchMember
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel<List<MemberModel>>> searchMember({String? keyword}) async {
    try {
      var res = await _dioAuth.get(
        ApiRouter.searchMember,
        queryParameters: { 'keyword': keyword }
      );
      var raw = RawSuccessModel.fromMap(res.data);
      return ResponseModel<List<MemberModel>>(
        type: ResponseModelType.success,
        data: (raw.data as List)
            .map(
              (e) => MemberModel.fromMap(e),
        )
            .toList(),
      );
    } on DioError catch (ex) {
      if (ex.error is AppMessage) {
        return ResponseModel<List<MemberModel>>(
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
        return ResponseModel<List<MemberModel>>(
          type: ResponseModelType.failure,
          message: AppMessage(
            type: AppMessageType.error,
            title: raw.error ?? txtErrorTitle,
            content: raw.message ?? 'Không có dữ liệu trả về!',
          ),
        );
      }
    } on Exception catch (ex) {
      return ResponseModel<List<MemberModel>>(
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
