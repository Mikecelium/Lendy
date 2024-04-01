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

import 'FirebaseUploadLocation.dart';


class UploadCommentsPage extends StatefulWidget {
  final String documentId;

  const UploadCommentsPage({Key? key, required this.documentId}) : super(key: key);

  @override
  State<UploadCommentsPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadCommentsPage> {
  final _formKey = GlobalKey<FormState>();
  final _authorController = TextEditingController();
  final _commentController = TextEditingController();

  Future<void> _addCommentToItem() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Reference to the 'rentalItems' collection
    final postsRef = FirebaseFirestore.instance.collection('rentalItems');

    // Reference to the 'Comments' subcollection in the specified document
    final commentsRef = postsRef.doc(widget.documentId).collection('Comments');

    // Add a comment document to the 'Comments' subcollection
    await commentsRef.add({
      'author': _authorController.text,
      'comment': _commentController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comment Added!')),
    );

    // Optionally reset form fields or navigate away
    _formKey.currentState!.reset();
    //Navigator.pop(context);

    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload More Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an author';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(labelText: 'Comment'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a comment';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addCommentToItem,
                child: const Text('Add Comment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}