import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'GoRoutes.dart';

import 'package:go_router/go_router.dart';

import 'FirebaseUploadLocation.dart';



class TextInfoPage extends StatefulWidget {
  final List<String> imageUrls;

  TextInfoPage({Key? key, required this.imageUrls}) : super(key: key);

  @override
  _TextInfoPageState createState() => _TextInfoPageState();
}

class _TextInfoPageState extends State<TextInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  
  final _idController = TextEditingController(); // Controller for item ID
  final _rentalPriceController = TextEditingController(); // Controller for rental price
  final _descriptionController = TextEditingController(); // Controller for rental price



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Text Information"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Added SingleChildScrollView for better form handling
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: 'ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),

                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                
                TextFormField(
                  controller: _rentalPriceController,
                  decoration: InputDecoration(labelText: 'Rental Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the rental price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Proceed to the next page and pass all the data
                      // Example navigation, adjust according to your navigation setup
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationInputPage(
                            imageUrls: widget.imageUrls,
                            id: _idController.text,
                            title: _titleController.text,
                            
                            rentalPrice: _rentalPriceController.text,
                            description: _descriptionController.text,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}