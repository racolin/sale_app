import 'package:flutter/foundation.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {
  AuthInitial() {
    print(runtimeType);
  }
}

class AuthNoLogin extends AuthState {
  AuthNoLogin() {
    print(runtimeType);
  }
}

class AuthLogin extends AuthState {
  AuthLogin() {
    print(runtimeType);
  }
}
