import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


Future<void> copyRentalItem(String sourceDocId, String newDocId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference rentalItems = firestore.collection('rentalItems');

  DocumentSnapshot sourceDocumentSnapshot = await rentalItems.doc(sourceDocId).get();

  if (sourceDocumentSnapshot.exists) {
    Map<String, dynamic> data = sourceDocumentSnapshot.data() as Map<String, dynamic>;
    
    // Print each field in the document
    data.forEach((key, value) {
      print('$key: $value');
    });

    await rentalItems.doc(newDocId).set(data);
    print('Rental item copied successfully');
  } else {
    print('Source rental item does not exist');
  }
} 








class CopyFirestoreDoc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Copy Document in Firestore'),
        ),
        body: CopyDocumentForm(),
      ),
    );  
  }
}

class CopyDocumentForm extends StatefulWidget {
  @override
  _CopyDocumentFormState createState() => _CopyDocumentFormState();
}

class _CopyDocumentFormState extends State<CopyDocumentForm> {
  final _formKey = GlobalKey<FormState>();
  final _sourceController = TextEditingController();
  final _destinationController = TextEditingController();

  @override
  void dispose() {
    _sourceController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _sourceController,
              decoration: InputDecoration(labelText: 'Source Document ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the source document ID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _destinationController,
              decoration: InputDecoration(labelText: 'New Document ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the new document ID';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    copyRentalItem(_sourceController.text, _destinationController.text);
                  }
                },
                child: Text('Copy Document'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}