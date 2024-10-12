import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_it/view/splash_screen.dart';
import 'package:plan_it/view/utils.dart';
import 'package:workmanager/workmanager.dart';
import 'Controllers/task_controller.dart';
import 'Services/notification_services.dart';
import 'db/db_helper.dart';
import 'db/shared_prefrence.dart';

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    print('&&&&& Task Run: $taskName &&&&&');
    Utils().showToastMessage('Background Services Started');
    NotificationService.showNotification(
      title: "Simple Notification",
      body: "Notification from Work Manager after Every 15 Minutes",
    );
    if(DateTime.now().hour==0){
      // TaskController().startBackgroundTask();
    }
    TaskController().startBackgroundTask();
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDB();
  await NotificationService.initializeNotification();
  Workmanager().initialize(callbackDispatcher);
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
