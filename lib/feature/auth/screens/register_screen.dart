import 'package:car_rongsok_app/shared/widgets/app_loader_overlay.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/custom_app_bar.dart';
import 'package:car_rongsok_app/shared/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(),
        body: ScreenWrapper(child: Center(child: AppText('RegisterScreen'))),
      ),
    );
  }
}
