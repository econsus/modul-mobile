// views/note_home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';

class NoteHomePage extends StatelessWidget {
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3689247972.
  final NoteController noteController = Get.put(NoteController());
  final TextEditingController _textEditingController = TextEditingController();
  String? _imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GetX Note Taking App with random Unsplash Images'),
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
              _imageUrl = await noteController.fetchRandomImage();
              if (_imageUrl == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to fetch image')));
              }
            },

            child: Text('Fetch Random Image'),
          ),

          ElevatedButton(
            onPressed: () {
              noteController.addNote(
                _textEditingController.text,
                _imageUrl,
              );
              _textEditingController.clear();
              _imageUrl = null; // Clear image path after adding the note
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
                        ? Image.network(
                            note.imagePath!,
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
