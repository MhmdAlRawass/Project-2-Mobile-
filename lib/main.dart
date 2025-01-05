//Mhmd Al Rawass - 32230645

import 'package:flutter/material.dart';
import 'package:project_2/screens/categories_list.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyApp(),
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 31, 54, 255))
            .copyWith(
          primary: Colors.black,
          secondary: const Color.fromARGB(255, 31, 54, 255),
          surface: const Color.fromARGB(255, 31, 54, 255),
          inverseSurface: const Color.fromARGB(255, 31, 54, 255),
          onPrimary: Colors.white,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryListScreen();
  }
}
