import 'package:sale_app/exception/app_message.dart';

import '../../data/models/pos_model.dart';

class PosState {
  final List<PosModel> listPos;
  final AppMessage? message;
  final int? index;

  PosState({
    required this.listPos,
    this.index,
    this.message,
  });

  List<String> get names => listPos
      .map(
        (e) => (e.title ?? 'Vãng lai'),
      )
      .toList();

  PosModel? get currentPos => index == null ? null : listPos[index!];

  PosState copyWith({
    List<PosModel>? listPos,
    int? index,
    AppMessage? message,
  }) {
    return PosState(
      listPos: listPos ?? this.listPos,
      index: index ?? this.index,
      message: message ?? this.message,
    );
  }
}
