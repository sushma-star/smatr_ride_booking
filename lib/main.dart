import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_ridebooking/services/hie_services.dart';
 import 'app.dart';
 import 'models/ride_type.dart';
import 'models/trip_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await HiveService.init();
  await Hive.openBox<Trip>('trips');
   runApp(  ProviderScope(child: MyApp()));
}
