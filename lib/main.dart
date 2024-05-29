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
