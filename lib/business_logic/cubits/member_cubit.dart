import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sale_app/data/models/response_model.dart';

import '../../business_logic/repositories/member_repository.dart';
import '../../data/models/member_model.dart';
import '../blocs/interval/interval_submit.dart';
import '../states/member_state.dart';

class MemberCubit extends Cubit<MemberState> implements IntervalSubmit<MemberModel> {
  final MemberRepository _repository;

  MemberCubit({
    required MemberRepository repository,
  })  : _repository = repository,
        super(MemberInitial()) {
    _init();
  }

  void _init() async {
    var res = await _repository.searchMember();
    if (res.type == ResponseModelType.failure) {
      return emit(MemberFailure(message: res.message));
    }

    emit(MemberLoaded(lists: res.data));
  }

  @override
  Future<List<MemberModel>> submit([String? key]) async {
    var res = await _repository.searchMember(keyword: key);
    return res.data;
  }

  IntervalSubmit<MemberModel> getSubmit() {
    return this;
  }
}
