// views/note_app.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';
import 'note_home_page.dart';

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Note Taking App with Images',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteHomePage(),
      initialBinding: BindingsBuilder(() {
        Get.put(NoteController());  // Initialize the controller globally
      }),
    );
  }
}
