import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DescriptionUploadPage extends StatefulWidget {
  @override
  _DescriptionUploadPageState createState() => _DescriptionUploadPageState();
}

class _DescriptionUploadPageState extends State<DescriptionUploadPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _rentalPriceController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _imagesUrlController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _idController.dispose();
    _rentalPriceController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _imagesUrlController.dispose();
    super.dispose();
  }

  Future<void> uploadDescription() async {
    String titleText = _descriptionController.text.trim();
    String idText = _idController.text.trim();
    num priceText = num.parse(_rentalPriceController.text.trim());
    num latitudeText = num.parse(_latitudeController.text.trim());
    num longitudeText = num.parse(_longitudeController.text.trim());
    //String imageUrlText = _imagesUrlController.text.trim();

    if (titleText.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('rentalItems').add({
          'title': titleText,
          'id': idText,
          'rentalPrice': priceText,
          'latitude': latitudeText,
          'longitude': longitudeText,
          //'images': List<String> imageUrlText,
          //'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Description uploaded successfully!')),
        );
        _descriptionController.clear();
        _idController.clear();
        _rentalPriceController.clear();
        _latitudeController.clear();
        _longitudeController.clear();
        //_imagesUrlController.clear();
      } catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload description')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Description'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: null,
            ),
            // TextField(
            //   controller: _idController,
            //   decoration: InputDecoration(labelText: 'ID'),
            // ),
            TextField(
              controller: _rentalPriceController,
              decoration: InputDecoration(labelText: 'Rental Price'),
            ),
            TextField(
              controller: _latitudeController,
              decoration: InputDecoration(labelText: 'Latitude'),
            ),
            TextField(
              controller: _longitudeController,
              decoration: InputDecoration(labelText: 'Longitude'),
            ),
            // TextField(
            //   controller: _imagesUrlController,
            //   decoration: InputDecoration(labelText: 'Image URLs (comma separated)'),
            // ),
            ElevatedButton(
  onPressed: uploadDescription,
  child: Text('Upload'),
  style: ElevatedButton.styleFrom(
    minimumSize: Size(100, 40), // Set the minimum button size
  ),
),
          ],
        ),
      ),
    );
  }
}