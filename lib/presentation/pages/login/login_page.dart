import 'package:deal_hunter/core/di/injectable.dart';
import 'package:deal_hunter/core/utils/constants.dart';
import 'package:deal_hunter/presentation/pages/login/google_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        bloc: getIt<LoginBloc>(), // Pass the loginBloc instance here
        listener: (context, state) {
          EasyLoading.dismiss();
          if (state is LoginSuccessState) {
            Navigator.pushReplacementNamed(context, '/home');
          }
         else if (state is LoginLoadingState) {
            EasyLoading.show(status: AppString.loadingText);
          }
          else if (state is LoginErrorState) {
            EasyLoading.showError(AppString.failedToLoginText);
          }
        },

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppString.loginText,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16.0),
              const GoogleLoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}
