// chats_addons/image_picker_addon.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImagePickerAddon extends StatelessWidget {
  final Function(String) onImageUploaded; // Callback para enviar la URL de la imagen

  const ImagePickerAddon({super.key, required this.onImageUploaded});

  Future<void> _uploadImage(XFile imageFile) async {
    const String apiKey = '524b12da6bb0a086f35948b25f4f58db'; // Tu API key de ImgBB
    final Uri uri = Uri.parse('https://api.imgbb.com/1/upload');

    // Convertir la imagen a base64
    final List<int> imageBytes = await imageFile.readAsBytes();
    final String base64Image = base64Encode(imageBytes);

    // Hacer la solicitud POST a ImgBB
    final response = await http.post(
      uri,
      body: {
        'key': apiKey,
        'image': base64Image,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String imageUrl = responseData['data']['url']; // URL de la imagen subida
      onImageUploaded(imageUrl); // Enviar la URL al callback
    } else {
      throw Exception('Error al subir la imagen');
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      await _uploadImage(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.image, color: Colors.blueAccent),
      onPressed: () => _pickImage(context),
    );
  }
}