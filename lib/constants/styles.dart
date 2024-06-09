import 'package:flutter/material.dart';

const textColour = Colors.black45;
const bold = FontWeight.w500;
var searchBarTheme = SearchBarThemeData(
  elevation: MaterialStateProperty.all(1),
  shape: MaterialStateProperty.all(RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(6.0),
  )),
  textStyle: MaterialStateProperty.all(
    const TextStyle(fontSize: 15, color: textColour, fontWeight: bold),
  ),
);

var filledButtonTheme = FilledButtonThemeData(
  style: FilledButton.styleFrom(
    backgroundColor: const Color(0xff273d28),
    disabledForegroundColor: textColour,
    disabledBackgroundColor: Colors.transparent,
    textStyle: const TextStyle(
      color: Colors.grey,
      fontSize: 18,
      fontWeight: bold,
    ),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
            color: const Color(0xff273d28).withOpacity(0.1), width: 0.8)),
  ),
);
