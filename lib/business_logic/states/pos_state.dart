import 'package:sale_app/exception/app_message.dart';

import '../../data/models/pos_model.dart';

class PosState {
  final List<PosModel> listPos;
  final AppMessage? message;

  PosState({
    required this.listPos,
    this.message,
  });

  PosState copyWith({
    List<PosModel>? listPos,
    AppMessage? message,
  }) {
    return PosState(
      listPos: listPos ?? this.listPos,
      message: message ?? this.message,
    );
  }
}