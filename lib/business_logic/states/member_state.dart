import 'package:flutter/foundation.dart';

import '../../data/models/member_model.dart';
import '../../exception/app_message.dart';

@immutable
abstract class MemberState {}

class MemberInitial extends MemberState {
  MemberInitial() {
    print(runtimeType);
  }
}

class MemberLoading extends MemberState {
  MemberLoading() {
    print(runtimeType);
  }
}

class MemberLoaded extends MemberState {
  final List<MemberModel> _lists;

  List<MemberModel> get lists => _lists;

  MemberLoaded({
    List<MemberModel>? lists,
  })  : _lists = lists ?? [] {
    print(runtimeType);
  }

  MemberLoaded copyWith({
    List<MemberModel>? lists,
  }) {
    return MemberLoaded(
      lists: lists ?? _lists,
    );
  }
}

class MemberFailure extends MemberState {
  final AppMessage message;

  MemberFailure({required this.message}) {
    print(runtimeType);
  }
}
