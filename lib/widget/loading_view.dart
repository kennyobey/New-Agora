import 'package:agora_care/core/constant/colors.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.8),
      child: Center(
        child: CircularProgressIndicator(color: AppColor().primaryColor),
      ),
    );
  }
}
