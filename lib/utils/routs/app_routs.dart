import 'package:flutter/material.dart';
import 'package:gemini_app/screen/splash/view/splash_screen.dart';
import '../../screen/history/view/history_screen.dart';
import '../../screen/home/view/home_screen.dart';

Map<String,WidgetBuilder>app_routs={
  "/":(context)=>SplashScreen(),
  "home":(context)=>HomeScreen(),
  "like":(context)=>HistoryScreen(),
};
