import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class AuthCubit extends Cubit<HomeState> {
  AuthCubit() : super(HomeInitialState());
}
