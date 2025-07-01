import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pet_adoption/constants/theme.dart';
import 'package:pet_adoption/controllers/theme_controller.dart';
import 'package:pet_adoption/screens/home.dart';

void main() async {
  Get.put(ThemeController());
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() => GetMaterialApp(
        themeMode: themeController.themeMode.value,
        theme: lightTheme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        home: HomeScreen()));
  }
}
