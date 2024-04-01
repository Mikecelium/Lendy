import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'GoRoutes.dart';

import 'package:go_router/go_router.dart';



class UploadFirestoreDoc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Rental Item'),
        ),
        body: RentalItemForm(),
      ),
    );
  }
}



class RentalItemForm extends StatefulWidget {
  @override
  _RentalItemFormState createState() => _RentalItemFormState();
}

class _RentalItemFormState extends State<RentalItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _idController = TextEditingController();
  final _priceController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();









  @override
  void dispose() {
    _titleController.dispose();
    _idController.dispose();
    _priceController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }



  // Example adjusted function - integrates image upload with item creation
Future<void> createRentalItemWithImage(BuildContext context) async {
  if (!_formKey.currentState!.validate()) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
    return;
  }

  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No image selected')));
    return;
  }

  // Show loading indicator here if you want

  File imageFile = File(pickedFile.path);
  String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
  Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
  UploadTask uploadTask = storageRef.putFile(imageFile);

  await uploadTask.whenComplete(() => null);
  String imageUrl = await storageRef.getDownloadURL();

  final collection = FirebaseFirestore.instance.collection('rentalItems');
  await collection.doc(_idController.text).set({
    'title': _titleController.text,
    'id': _idController.text,
    'rentalPrice': double.tryParse(_priceController.text) ?? 0,
    'latitude': double.tryParse(_latitudeController.text) ?? 0,
    'longitude': double.tryParse(_longitudeController.text) ?? 0,
    'images': [imageUrl], // Use the uploaded image URL
  });

  // Clear form fields and reset the form state if needed
  _formKey.currentState!.reset();
  // Hide loading indicator here

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rental Item Created with Image!')));
}




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Rental Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the rental price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the latitude';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the longitude';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () => createRentalItemWithImage(context),
                  child: Text('Create Rental Item with Image'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: Text('Back to Home'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey, // Adjust the button color if needed
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}