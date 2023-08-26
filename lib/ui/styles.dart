import 'package:flutter/material.dart';

// AppBar
Color appBarColor(BuildContext context) => Theme.of(context).colorScheme.inversePrimary;

// Buttons
const buttonHeight = 80.0;

// Text
TextStyle? textLarge(BuildContext context) => Theme.of(context).textTheme.headlineLarge;
TextStyle? textSmall(BuildContext context) => Theme.of(context).textTheme.headlineSmall;