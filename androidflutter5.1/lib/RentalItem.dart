// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:androidflutter/CircleLayer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For using Firestore


import 'NewRental.dart';


class RentalItem {
  final String id;
  final String title;
  final double rentalPrice;
  final List<String> images;
  final num latitude;
  final num longitude;
  final String description;

  //final List<String> comments;

  //final List<NewRental> rental_list;
  

  RentalItem({
    required this.id,
    required this.title,
    required this.rentalPrice,
    required this.images,
    required this.latitude,
    required this.longitude,
    required this.description,

    //required this.comments,
    //required this.rental_list,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'rentalPrice': rentalPrice,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,

      //'comments': comments,
      //'rental_list': rental_list,
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
      //comments: List<String>.from(map['comments']),   
      //rental_list: List<NewRental>.from(map['rental_list']),
    );
  }
}

Future<void> addRentalItem(RentalItem item) async {
  await FirebaseFirestore.instance.collection('rentalItems').doc(item.id).set(item.toMap());
}