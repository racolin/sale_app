import 'package:sale_app/data/models/employee_model.dart';
import 'package:sale_app/exception/app_message.dart';

import '../../data/models/pos_model.dart';

class PosState {
  final List<PosModel> listPos;
  final List<EmployeeModel> employees;
  final AppMessage? message;
  final int? index;
  final String? employeeId;

  PosState({
    required this.listPos,
    required this.employees,
    this.index,
    this.message,
    this.employeeId,
  });

  List<String> get names => listPos
      .map(
        (e) => (e.username ?? 'Vãng lai'),
      )
      .toList();

  PosModel? get currentPos => index == null ? null : listPos[index!];

  bool isSelected(String id) => id == employeeId;

  PosState copyWith({
    List<PosModel>? listPos,
    List<EmployeeModel>? employees,
    int? index,
    AppMessage? message,
    String? employeeId,
  }) {
    return PosState(
      listPos: listPos ?? this.listPos,
      employees: employees ?? this.employees,
      index: index ?? this.index,
      message: message ?? this.message,
      employeeId: employeeId ?? this.employeeId,
    );
  }
}
