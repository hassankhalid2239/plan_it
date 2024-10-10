import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_it/view/splash_screen.dart';
import 'Services/notification_services.dart';
import 'db/db_helper.dart';
import 'db/shared_prefrence.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDB();
  await NotificationService.initializeNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  MyApp({super.key});
  final SharedPref sharedPref=SharedPref();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlanIt',
      home:  SplashScreen(),
    );
  }
}
