import 'package:eaecontrol/configs/app_colors.dart';
import 'package:eaecontrol/views/scaffold_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.PRIMARY_COLOR,
        ),
        useMaterial3: true,
      ),
      home: const ScaffoldView(),
    );
  }
}
