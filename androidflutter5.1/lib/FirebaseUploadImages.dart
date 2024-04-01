import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'GoRoutes.dart';

import 'package:go_router/go_router.dart';

import 'FirebaseUploadText.dart';


// import statements

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];
  List<String> _imageUrls = [];

  Future<void> _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _images = selectedImages;
      });
    }
  }

  Future<void> _uploadImages() async {
    for (var image in _images) {
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}_${image.name}';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(File(image.path));
      await uploadTask.whenComplete(() => null);
      String imageUrl = await storageRef.getDownloadURL();
      _imageUrls.add(imageUrl);
    }

    // Navigate to next page and pass the URLs
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TextInfoPage(imageUrls: _imageUrls),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Images'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickImages,
            child: Text('Select Images'),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Image.file(File(_images[index].path));
              },
            ),
          ),
          ElevatedButton(
            onPressed: _uploadImages,
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}