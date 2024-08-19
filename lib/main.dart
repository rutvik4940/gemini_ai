import 'package:flutter/cupertino.dart';
import 'package:gemini_app/utils/routs/app_routs.dart';
import 'package:get/get.dart';
import 'package:theme_change/theme_change.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    Obx(
      () {
        ThemeChange.themeController.getTheme();
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          routes: app_routs,
          theme: ThemeChange.lightTheme,
          darkTheme: ThemeChange.darkTheme,
          themeMode: ThemeChange.themeController.mode.value,
        );
      },
    ),
  );
}
