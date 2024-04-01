import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart'; // Use rootBundle directly
import 'package:geojson/geojson.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'utils.dart';
import 'GoRoutes.dart';
import 'RentalItem.dart';
import 'firebase_options.dart';


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'RentalItem.dart'; // Ensure this import points to your RentalItem model

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'RentalItem.dart'; // Make sure this is correctly pointing to your RentalItem model
import 'package:carousel_slider/carousel_slider.dart';

class RentalSelectionPage extends StatefulWidget {
  final String annotationId;

  const RentalSelectionPage({Key? key, required this.annotationId}) : super(key: key);

  @override
  _RentalSelectionPageState createState() => _RentalSelectionPageState();
}

class _RentalSelectionPageState extends State<RentalSelectionPage> {
  late Future<RentalItem> rentalItemFuture;
  late Future<List<Map<String, dynamic>>> commentsFuture;

  @override
  void initState() {
    super.initState();
    rentalItemFuture = fetchRentalItem();
    commentsFuture = fetchComments(); // Fetch comments on init
  }

  Future<RentalItem> fetchRentalItem() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('rentalItems')
        .doc(widget.annotationId)
        .get();
    return RentalItem.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<List<Map<String, dynamic>>> fetchComments() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('rentalItems')
        .doc(widget.annotationId)
        .collection('Comments')
        .get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rental Details'),
      ),
      body: FutureBuilder<RentalItem>(
        future: rentalItemFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            RentalItem item = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: Theme.of(context).textTheme.headline5),
                    SizedBox(height: 8),
                    Text('\$${item.rentalPrice.toString()} per day', style: Theme.of(context).textTheme.headline6?.copyWith(color: Theme.of(context).primaryColor)),
                    SizedBox(height: 16),
                    Text('\$${item.rentalPrice.toString()} per day', style: Theme.of(context).textTheme.headline6?.copyWith(color: Theme.of(context).primaryColor)),
                    SizedBox(height: 16),
                    Text(item.description, style: Theme.of(context).textTheme.bodyText1),
                    SizedBox(height: 16),
                    CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 16/9,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        autoPlay: true,
                      ),
                      items: item.images.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: 1000,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: commentsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                          List<Map<String, dynamic>> comments = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              var comment = comments[index];
                              return ListTile(
                                title: Text(comment['author'] ?? 'Anonymous'),
                                subtitle: Text(comment['comment'] ?? ''),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error loading comments');
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}