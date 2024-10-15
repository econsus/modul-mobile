import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Note Taking App with Images',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: NoteHomePage(),
    );
  }
}

// Data model for Note
class Note {
  final String text;
  final String? imagePath;

  Note({
    required this.text,
    this.imagePath,
  });
}

// Controller using GetX for managing state
class NoteController extends GetxController {
  var notes = <Note>[].obs;  // Observable list of notes

  final ImagePicker _picker = ImagePicker();

  // Method to add a note with or without an image
  void addNote(String noteText, String? imagePath) {
    if (noteText.isNotEmpty || imagePath != null) {
      notes.add(Note(text: noteText, imagePath: imagePath));
    }
  }

  // Method to delete a note by index
  void deleteNoteAtIndex(int index) {
    notes.removeAt(index);
  }

  // Method to pick an image
  Future<String?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }
}

class NoteHomePage extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());
  final TextEditingController _textEditingController = TextEditingController();
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GetX Note Taking App with Images'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your note',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              _imagePath = await noteController.pickImage();
            },
            child: Text('Pick Image'),
          ),
          ElevatedButton(
            onPressed: () {
              noteController.addNote(
                _textEditingController.text,
                _imagePath,
              );
              _textEditingController.clear();
              _imagePath = null;  // Clear image path after adding the note
            },
            child: Text('Add Note'),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: noteController.notes.length,
                itemBuilder: (context, index) {
                  final note = noteController.notes[index];
                  return ListTile(
                    title: Text(note.text),
                    leading: note.imagePath != null
                        ? Image.file(
                            File(note.imagePath!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : null,
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        noteController.deleteNoteAtIndex(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
