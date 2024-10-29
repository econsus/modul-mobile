// controllers/note_controller.dart
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/note_model.dart';

class NoteController extends GetxController {
  var notes = <Note>[].obs; // Observable list of notes

  static const String accessKey =
      '_Bsm5RRliEwL_U8oCgrBHzrWTmDY-5S9NO2sbI3ztsg'; // Replace with your access key
  static const String secretKey =
      'YxD4LCt0EE9-DhsvywE7OfsUu3M5Mh6TQvI0FAHUG5o'; // Replace with your secret key

  final ImagePicker _picker = ImagePicker();

  // Method to add a note with or without an image
  void addNote(String noteText, String? imageURL) {
    if (noteText.isNotEmpty || imageURL != null) {
      notes.add(Note(text: noteText, imagePath: imageURL));
    }
  }

  // Method to delete a note by index
  void deleteNoteAtIndex(int index) {
    notes.removeAt(index);
  }

  // Get random image from Unsplash
  Future<String?> fetchRandomImage() async {
    final response = await http.get(
      Uri.parse('https://api.unsplash.com/photos/random?client_id=$accessKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['urls']['small']; //Get image URL
    } else {
      print('Failed to load image');
      return null;
    }
  }
  // Method to pick an image
  /*Future<String?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }*/
}
