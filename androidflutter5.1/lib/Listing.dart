import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'RentalItem.dart'; // Assuming you have this model class to represent each rental item
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'GoRoutes.dart';
import 'NearbyListings.dart';

class RentalItemDetailPage extends StatelessWidget {
  final RentalItem rentalItem;

  RentalItemDetailPage({required this.rentalItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rentalItem.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            (rentalItem.images.isNotEmpty)
                ? Image.network(rentalItem.images.first, fit: BoxFit.cover)
                : Container(color: Colors.grey, height: 200), // Placeholder in case of no image
            SizedBox(height: 8),
            Text("\$${rentalItem.rentalPrice} per day", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            //Text(rentalItem.description ?? "No description provided."), // Assuming your model has a description field
          ],
        ),
      ),
    );
  }
}