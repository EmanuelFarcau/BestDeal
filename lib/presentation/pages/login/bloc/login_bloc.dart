import 'package:bloc/bloc.dart';
import 'package:deal_hunter/core/utils/constants.dart';
import 'package:deal_hunter/domain/repositories_contract/login_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc, Emitter;
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

@singleton
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _googleLogin;

  LoginBloc(this._googleLogin) : super(LoginInitial()) {
    on<GoogleLoginEvent>(_handleGoogleLoginEvent);

  }

  void _handleGoogleLoginEvent(
      GoogleLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());

    final googleUser = await _googleLogin.googleSignIn();

    googleUser.fold(
      (failure) => emit(LoginErrorState(AppString.failedToLoginText)),
      (success) => emit(LoginSuccessState()),
    );
  }
}
