/*



import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'RentalItem.dart'; // Assuming this is your model
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UploadItemPage extends StatefulWidget {
  @override
  _UploadItemPageState createState() => _UploadItemPageState();
}

class _UploadItemPageState extends State<UploadItemPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  double rentalPrice = 0.0;
  List<XFile>? images; // Using XFile to handle image files

  Future<void> pickImages() async {
    final ImagePicker _picker = ImagePicker();
    // Pick multiple images
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        images = selectedImages;
      });
    }
  }


  Future<void> uploadItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        List<String> imageUrls = await uploadImages();
        // Assume RentalItem has a method to convert to Map and includes imageUrls
        await FirebaseFirestore.instance.collection('rentalItems').add({
          'title': title,
          'rentalPrice': rentalPrice,
          'imageUrls': imageUrls,
          // Add other fields as needed
        });
        Navigator.pop(context); // Return to the previous screen on success
      } catch (e) {
        // Handle errors, e.g., show a Snackbar with the error message
        print(e); // Log the error
      }
    }
  }

  Future<List<String>> uploadImages() async {
    List<String> uploadedUrls = [];
    for (var imageFile in images!) {
      File file = File(imageFile.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + basename(imageFile.path); // A unique file name
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('uploads/$fileName');

      firebase_storage.UploadTask uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() async {
        String downloadUrl = await ref.getDownloadURL();
        uploadedUrls.add(downloadUrl);
      }).catchError((onError) {
        print(onError);
        throw onError; // Throw an error to catch it in the calling function
      });
    }
    return uploadedUrls;
  }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload New Item")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              onSaved: (value) => title = value!,
              validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Rental Price'),
              keyboardType: TextInputType.number,
              onSaved: (value) => rentalPrice = double.parse(value!),
              validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
            ),
            ElevatedButton(
              onPressed: pickImages,
              child: Text('Pick Images'),
            ),
            // Display picked images if any
            if (images != null)
              Wrap(
                spacing: 8,
                children: images!.map((image) => Image.file(File(image.path), width: 100, height: 100)).toList(),
              ),
            ElevatedButton(
              onPressed: uploadItem,
              child: Text('Upload Item'),
            ),
          ],
        ),
      ),
    );
  }

  */
