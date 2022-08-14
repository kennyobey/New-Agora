import 'dart:io';

import 'package:agora_care/app/onboarding/splashscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_routes.dart';

Route generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashScreen:
      return _buildPageRoute(
        page: SplashScreen(),
      );
      // ignore: dead_code
      break;
    default:
      return _errorRoute();
  }
}

Route _buildPageRoute({@required Widget? page}) {
  if (Platform.isIOS) {
    return CupertinoPageRoute(builder: (builder) => page!);
  } else {
    return MaterialPageRoute(builder: (builder) => page!);
  }
}

Route _errorRoute() {
  return MaterialPageRoute(
    builder: (context) {
      return const Scaffold(
        body: Center(
          child: Text('Page not found'),
        ),
      );
    },
  );
}
