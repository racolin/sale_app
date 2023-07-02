import 'package:flutter_bloc/flutter_bloc.dart';
import '../../exception/app_message.dart';
import '../states/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(type: HomeBodyType.order));

  // base method: return response model, use to avoid repeat code.

  // action method, change state and return AppMessage?, null when success

  // get data method: return model if state is loaded, else return null

  // Action UI
  AppMessage? setBody(HomeBodyType type) {
    emit(state.copyWith(type: type));

    return null;
  }
}
