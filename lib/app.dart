import 'package:flutter/material.dart';
import 'package:smart_ridebooking/provider/theme_provider.dart';
import 'core/theme.dart';
import 'features/dashboard/dashboard_screen.dart';
 import 'package:flutter_riverpod/flutter_riverpod.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Ride Booking',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: mode,
      home: const DashboardScreen(),
      navigatorKey: navigatorKey,
    );
  }
}

