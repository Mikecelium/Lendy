// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For using Firestore

class NewRental {

final String rental_title;

  final String rental_identifier;
  final double rental_totalprice; // New field to store the URL

  final int rental_id;

  final DateTime rental_timestamp;

  final DateTime rentalStart;

  final DateTime rentalEnd;

  NewRental({
    required this.rental_id,
    
    
    required this.rental_timestamp,

    required this.rental_title,

    required this.rental_identifier, 

    required this.rental_totalprice, 

    required this.rentalStart,

    required this.rentalEnd,



  
});

}




/*
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'rentalPrice': rentalPrice,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
    };
  }

  static RentalItem fromMap(Map<String, dynamic> map) {
    return RentalItem(
      id: map['id'],
      title: map['title'],
      rentalPrice: map['rentalPrice'],
      images: List<String>.from(map['images']),
      latitude: map['latitude'],
      longitude: map['longitude'],
      description: map['description'],
    );
  }
}

Future<void> addRentalItem(RentalItem item) async {
  await FirebaseFirestore.instance.collection('rentalItems').doc(item.id).set(item.toMap());
}

*/