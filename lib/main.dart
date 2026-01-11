import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_ridebooking/services/hie_services.dart';
import 'package:smart_ridebooking/utils/notifications_services.dart';
 import 'app.dart';
 import 'models/trip_model.dart';


import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await NotificationService.init();
  await requestNotificationPermission();
   await Hive.initFlutter();
  await HiveService.init();
  await Hive.openBox<Trip>('trips');

  runApp(const ProviderScope(child: MyApp()));
}
