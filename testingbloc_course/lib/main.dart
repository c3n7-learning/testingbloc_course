import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testingbloc_course/firebase_options.dart';

import 'dart:developer' as devtools show log;

import 'package:testingbloc_course/views/app.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const App(),
  );
}
