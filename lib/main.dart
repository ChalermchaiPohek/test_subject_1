import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_subject_1/my_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const MethodChannel('flavor')
      .invokeMethod<String>('getFlavor')
      .then((value) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ])
        .then((_) {
      return runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyApp(
            buildFlavor: value,
          ),
        ),
      );
    },);
  },);
}