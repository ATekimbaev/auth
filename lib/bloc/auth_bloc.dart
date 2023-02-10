import 'package:bloc/bloc.dart';
import 'package:login_by_phonenumber/auth_repo.dart';
import 'package:login_by_phonenumber/dio_settings.dart';
import 'package:login_by_phonenumber/models/send_phone_model.dart';
import 'package:meta/meta.dart';

import '../models/send_code_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.repo}) : super(AuthInitial()) {
    on<SendPhoneEvent>(
      (event, emit) async {
        if (event.phoneNumber.length < 12) {
          emit(AuthError());
        } else {
          try {
            final model = await repo.sendPhone(phoneNumber: event.phoneNumber);
            emit(AuthSucces(model: model));
          } catch (e) {
            emit(AuthError());
          }
        }
      },
    );
    on<SendCodeEvent>(
      (event, emit) async {
        try {
          final model = await repo.sendCode(code: event.code);
          emit(AuthCodeSucces(model: model));
        } catch (e) {
          emit(
            AuthError(),
          );
        }
      },
    );
  }
  final AuthRepo repo;
}
