import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'widgets/recipe_app.dart';
import 'providers/navigation.dart';

main() async {
  final prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: MaterialApp(
        home: const RecipeApp(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange),
          textTheme: const TextTheme(
              titleMedium: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 20.0,
                  color: Color.fromRGBO(55, 71, 79, 1))),
        ),
      )));
}
