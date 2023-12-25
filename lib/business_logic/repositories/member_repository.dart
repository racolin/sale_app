import '../../data/models/member_model.dart';
import '../../data/models/response_model.dart';

abstract class MemberRepository {

  //paging
  Future<ResponseModel<List<MemberModel>>> searchMember({String? keyword});

  // get member
  Future<ResponseModel<MemberModel>> getMember();
}
