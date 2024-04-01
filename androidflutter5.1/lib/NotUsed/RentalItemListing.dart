// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


//import 'package:androidflutter/RentalItem.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 // For using Firestore
import 'package:firebase_core/firebase_core.dart';



import '../RentalItem.dart';

import '../firebase_options.dart';


class RentalItemsList extends StatefulWidget {
  @override
  _RentalItemsListState createState() => _RentalItemsListState();
}

class _RentalItemsListState extends State<RentalItemsList> {
  Future<List<RentalItem>> fetchRentalItems() async {
    // Fetch data from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('rentalItems').get();

    // Convert documents to RentalItem objects
    List<RentalItem> rentalItems = snapshot.docs.map((doc) {
      return RentalItem.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    return rentalItems;
  }




  Future<void> initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  } catch (e) {
    print(e);
    print('firebase error'); // Handle the error or log it
  }
}







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rental Items"),
      ),
      body: FutureBuilder<List<RentalItem>>(
        future: fetchRentalItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("An error occurred!"));
          } else {
            // Data is fetched successfully
            List<RentalItem> rentalItems = snapshot.data!;
            return ListView.builder(
              itemCount: rentalItems.length,
              itemBuilder: (context, index) {
                RentalItem item = rentalItems[index];
                return ListTile(
                  leading: (item.images.isNotEmpty)
                      ? Image.network(item.images.first, width: 100, height: 100, fit: BoxFit.cover)
                      : SizedBox(width: 100, height: 100), // Placeholder in case of no image
                  title: Text(item.title),
                  subtitle: Text("\$${item.rentalPrice} per day"),
                );
              },
            );
          }
        },
      ),
    );
  }
}