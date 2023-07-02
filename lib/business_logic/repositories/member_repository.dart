import '../../data/models/response_model.dart';

abstract class MemberRepository {

  //paging
  Future<ResponseModel<List>> searchMember();

  // get member
  Future<ResponseModel<int>> getMember();
}
