
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_store/screens/loginScreen.dart';
import 'package:smart_store/screens/navigationScreen.dart';

import 'models/auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (BuildContext context) => AuthModel()..init(),
      child: Consumer<AuthModel>(
        builder: (context, authModel, child) {
          return MaterialApp(
            title: 'Smart Store',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: authModel.isAuthorized ? const NavigationScreen() : const LoginScreen()
          );
        }
      ),
    );
  }
}
