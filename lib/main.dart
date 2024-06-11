import 'package:flutter/material.dart';
import 'package:location_app/constants/styles.dart';
import 'views/homepage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: textColour),
      filledButtonTheme: filledButtonTheme,
      searchBarTheme: searchBarTheme,
    ),
    home: const HomePage(showCountry: false),
  ));
}
