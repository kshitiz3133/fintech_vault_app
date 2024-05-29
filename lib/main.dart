import 'package:fintech_vault_app/biometrics.dart';
import 'package:fintech_vault_app/bubble.dart';
import 'package:fintech_vault_app/startanimation.dart';
import 'package:fintech_vault_app/timercount.dart';
import 'package:fintech_vault_app/vault.dart';
import 'package:flutter/material.dart';

import 'auth.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      //themeMode: ThemeMode.light,
      /* ThemeMode.system to follow system theme,
         ThemeMode.light for light theme,
         ThemeMode.dark for dark theme
      */
      home: HomePage(),
    );
  }
}


/*

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartAnimation(),
      //home: Bubble(),
      //home: VaultHome(),
    );
  }
}
*/
