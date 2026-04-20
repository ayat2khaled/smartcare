import 'package:first_project/screens/splash_screen.dart';
import 'package:first_project/themes/theme_provider.dart';
import 'package:first_project/providers/cart_provider.dart';
import 'package:first_project/providers/order_provider.dart';
import 'package:first_project/providers/notification_provider.dart';
import 'package:first_project/providers/rewards_provider.dart';
import 'package:first_project/providers/booking_provider.dart';
import 'package:first_project/utils/top_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => RewardsProvider()),
        ChangeNotifierProvider(create: (context) => BookingProvider()),
      ],
      child: const SmartCareApp(),
    ),
  );
}

class SmartCareApp extends StatelessWidget {
  const SmartCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'SmartCare',
      theme: ThemeProvider.lightTheme,
      darkTheme: ThemeProvider.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}