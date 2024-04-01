import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'GoRoutes.dart';

import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';


class LocationInputPage extends StatefulWidget {
  final List<String> imageUrls;
  final String title;
  final String id;
  final String rentalPrice;
  final String description;

  const LocationInputPage({
    Key? key,
    required this.imageUrls,
    required this.title,
    required this.id,
    required this.rentalPrice,
    required this.description, 
  }) : super(key: key);

  @override
  _LocationInputPageState createState() => _LocationInputPageState();
}

class _LocationInputPageState extends State<LocationInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  Future<void> _createRentalItem() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final collection = FirebaseFirestore.instance.collection('rentalItems');
    await collection.doc(widget.id).set({
      'title': widget.title,
      'id': widget.id,
      'rentalPrice': double.tryParse(widget.rentalPrice) ?? 0,
      'latitude': double.tryParse(_latitudeController.text) ?? 0,
      'longitude': double.tryParse(_longitudeController.text) ?? 0,
      'images': widget.imageUrls, // Reusing the uploaded image URLs
      'description': widget.description, // added description
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rental Item Created!')));

    // Reset form or navigate away
    _formKey.currentState!.reset();
    context.go('/FirestoreUploadComments', extra: widget.id); // Adjust navigation as necessary
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Location Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a latitude';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a longitude';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createRentalItem,
                child: Text('Create Rental Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}