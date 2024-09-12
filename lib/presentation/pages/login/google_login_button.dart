import 'package:deal_hunter/core/di/injectable.dart';
import 'package:deal_hunter/core/utils/constants.dart';
import 'package:deal_hunter/presentation/pages/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton.icon(
        icon: Image.asset(
          AppString.googleLogoImagePath,
          height: 24,
        ),
        label: const Text(AppString.registerWithGoogleText),
        onPressed: () {
          getIt<LoginBloc>().add(GoogleLoginEvent());
        },
      ),
    );
  }
}
