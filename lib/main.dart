import 'package:agora_care/app/onboarding/splashscreen.dart';
import 'package:agora_care/binding/appbinding.dart';
import 'package:agora_care/core/constant/app_palette.dart';
import 'package:agora_care/core/constant/colors.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    DevicePreview(
      enabled: true,
      builder: (BuildContext context) => const AgoraCare(),
    ),
  );
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//   runApp(const AgoraCare());
// }

class AgoraCare extends StatelessWidget {
  const AgoraCare({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: AppBinding(),
        title: 'Agora Care Mobile App',
        darkTheme: Get.isDarkMode ? ThemeData.dark() : ThemeData.light(),

        theme: ThemeData(
          fontFamily: 'HK GROTESK',
          primarySwatch: Palette.primaryColor,
          primaryColor: AppColor().primaryColor,
        ),
        onGenerateRoute: generateRoute,
        home: SplashScreen(),
        // home: const VerifyMobile(),
      ),
    );
  }
}
