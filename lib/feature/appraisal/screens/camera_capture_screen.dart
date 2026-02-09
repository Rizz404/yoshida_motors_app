import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:car_rongsok_app/shared/widgets/custom_app_bar.dart';
import 'package:car_rongsok_app/shared/widgets/screen_wrapper.dart';
import 'package:flutter/material.dart';

class CameraCaptureScreen extends StatelessWidget {
  const CameraCaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ScreenWrapper(child: Center(child: AppText('CameraCaptureScreen'))),
    );
  }
}
