// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:androidflutter/GoRoutes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For using Firestore

import 'TrafficDirections.dart';




/// This sample app shows an app with two screens.
///
/// The first route '/' is mapped to [HomeScreen], and the second route
/// '/details' is mapped to [DetailsScreen].
///
/// The buttons use context.go() to navigate to each destination. On mobile
/// devices, each destination is deep-linkable and on the web, can be navigated
/// to using the address bar.



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  } catch (e) {
    print(e);
    print('firebase error'); // Handle the error or log it
  }
  runApp(MyApp());
}



class RentalItem {
  final String id;
  final String title;
  final double rentalPrice;
  final List<String> images;

  RentalItem({
    required this.id,
    required this.title,
    required this.rentalPrice,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'rentalPrice': rentalPrice,
      'images': images,
    };
  }

  static RentalItem fromMap(Map<String, dynamic> map) {
    return RentalItem(
      id: map['id'],
      title: map['title'],
      rentalPrice: map['rentalPrice'],
      images: List<String>.from(map['images']),
    );
  }
}

Future<void> addRentalItem(RentalItem item) async {
  await FirebaseFirestore.instance.collection('rentalItems').doc(item.id).set(item.toMap());
}




void addExampleData() async {
  List<Map<String, dynamic>> rentalItemsData = [
    {
      "id": "rental001",
      "title": "Mountain Bike",
      "rentalPrice": 25.00,
      "images": ["https://c02.purpledshub.com/uploads/sites/39/2020/06/Santa-Cruz-5010-CC-X01-RSV-25-1ddbe5a.jpg?w=775&webp=1", "https://marketplacer.imgix.net/gE/rIxZ5HR4G3lgZINUv1ApapoTw.png?auto=format&fm=pjpg&fit=max&s=db6d83f87a7f86297cb7317489149022"],
    },
    {
      "id": "rental002",
      "title": "Kayak for Two",
      "rentalPrice": 40.00,
      "images": ["https://www.aucklandseakayaks.co.nz/wp-content/uploads/2021/11/ASK-07_small-2048x1365.jpg", "https://socialnaturemovement.nz/wp-content/uploads/2021/06/IMG_E0703-scaled.jpg"],
    },
    {
      "id": "rental003",
      "title": "Luxury Camping Tent",
      "rentalPrice": 50.00,
      "images": ["https://assets.atdw-online.com.au/images/4136c6a3eedf323a9af19ab0aaf5c3c1.jpeg?w=900", "https://cf.bstatic.com/xdata/images/hotel/max1024x768/411712571.jpg?k=399a0bcd7c88771490c83691a0c65dabfdbb1ab142abca8ed61caf8ea770c7e1&o=&hp=1"],
    },
    {
      "id": "rental004",
      "title": "Digital Camera Package",
      "rentalPrice": 75.00,
      "images": ["https://www.ozdigitalonline.com/img/products/2879_nikon-d7500-18-140-kit-20.9mp-4k-ultrahd-digital-slr-camera~80010261.webp?", "https://www.camerahouse.com.au/media/catalog/product/7/8/788.jpg?width=600&height=556&optimize=medium&fit=bounds"],
    },
    {
    "id": "rental005",
    "title": "Electric Scooter",
    "rentalPrice": 30.00,
    "images": [
      "https://global.honda/en/stories/070/images/g08.jpg",
      "https://imgd.aeplcdn.com/1280x720/n/cw/ec/148531/honda-right-side-view2.jpeg?isig=0"
    ],
  },
  {
    "id": "rental006",
    "title": "Stand Up Paddleboard",
    "rentalPrice": 45.00,
    "images": [
      "https://example.com/paddleboard1.jpg",
      "https://example.com/paddleboard2.jpg"
    ],
  },
  {
    "id": "rental007",
    "title": "Professional DSLR Camera",
    "rentalPrice": 100.00,
    "images": [
      "https://www.cameralabs.com/wp-content/uploads/2019/08/canon-eos-90d-hero-1-1920x1441.jpg",
      "https://i1.adis.ws/i/canon/1263C047_EOS-80D-EF-S-18-135mm-f_3.5-5.6-IS-USM_8/canon-eos-80d-18-135mm-is-usm-lens-camera-on-sports-field-with-blurry-background?w=450&bg=white&fmt=webp"
    ],
  },
  {
    "id": "rental008",
    "title": "Snowboard Set",
    "rentalPrice": 60.00,
    "images": [
      "https://cdn.shoplightspeed.com/shops/614323/files/27432256/used-snowboard-stuf-conquest-128cm.jpg",
      "https://i.ebayimg.com/images/g/w6wAAOSw3BFlK7rU/s-l1200.jpg"
    ],
  },
  {
    "id": "rental009",
    "title": "Portable Projector",
    "rentalPrice": 20.00,
    "images": [
      "https://i.ebayimg.com/images/g/9GMAAOSwDKhkZnm0/s-l1200.jpg",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDHp5iqz00fis_L5pJOGdUxspjo8q8LFPwQFvYpiOQ8vxNZa1TD1r3muLHoTY1aUQczNQ&usqp=CAU"
    ],
  },
  {
    "id": "rental010",
    "title": "Fishing Rod Kit",
    "rentalPrice": 35.00,
    "images": [
      "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Angler_at_devizes_england_arp.jpg/1200px-Angler_at_devizes_england_arp.jpg",
      "https://www.shropshirestar.com/resizer/092HC9hN-api9_0zZ5Laoh9agBg=/1200x0/cloudfront-us-east-1.images.arcpublishing.com/mna/UWNG5S6X3VEVBCXT6QKVIVN7OY.jpg"
    ],
  },
  {
    "id": "rental011",
    "title": "Hiking Backpack",
    "rentalPrice": 22.00,
    "images": [
      "https://www.sevenhorizons.com.au/cdn/shop/products/Wilderness-Equipment-breakout-75-litre-top-loading-canvas-hiking-backpack-navy_grande.jpg?v=1652404425",
      "https://aspireadventureequipment.com.au/wp-content/uploads/2021/03/Pack-101_Navy-Black_1-500x500.jpg"
    ],
  },
  {
    "id": "rental012",
    "title": "4-Person Inflatable Boat",
    "rentalPrice": 85.00,
    "images": [
      "https://m.media-amazon.com/images/I/81J1I6A3NFL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/715AiJgdpHL._AC_UF894,1000_QL80_.jpg"
    ],
  },
];

  for (var itemData in rentalItemsData) {
    RentalItem item = RentalItem.fromMap(itemData);
    await addRentalItem(item);
  }
}










/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
    );
  }
}

/// The home screen
class HomeScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [


            
            ElevatedButton(
              onPressed: () => context.go('/Map'),
              child: const Text('Go to the Details screen'),
            ),





            const SizedBox(height: 20), // Add space between the buttons
            ElevatedButton(
              onPressed: () => context.go('/authentication'), 
              child: const Text('Login'),
            ),







            const SizedBox(height: 20), // Add space between the buttons
            ElevatedButton(
              onPressed: () => context.go('/Nearby_Listings'), 
              child: const Text('Nearby'),
            ),








            const SizedBox(height: 20), // Add space between the buttons
            ElevatedButton(
              onPressed: () => context.go('/Calendar'), 
              child: const Text('Calendar'),
            ),








            const SizedBox(height: 20), // Add space between the buttons
            ElevatedButton(
              onPressed: () => addExampleData(), 
              child: const Text('Upload Example Data'),
            ),







             const SizedBox(height: 20), // Add space between the buttons
            ElevatedButton(
              onPressed: () => context.go('/rentalItems'), // Navigate to RentalItemsList screen
              child: const Text('View Rental Items'),
            ),








            ElevatedButton(
              onPressed: () => context.go('/Lendy'), // Navigate to Lendy
              child: const Text('Rental Dashboard'),
            ),








            ElevatedButton(
              onPressed: () => context.go('/Lendy'), // Navigate to Lendy
              child: const Text('Rental Dashboard'),
            ), 



              ElevatedButton(
              onPressed: () => context.go('/FirestoreCopy'), // Navigate to Lendy
              child: const Text('Copy Firestore Doc'),
            ), 




               ElevatedButton(
              onPressed: () => context.go('/FirestoreUpload'), // Navigate to Lendy
              child: const Text('Upload Firestrore Doc'),
            ), 




            /*
            ElevatedButton(
              onPressed: () => context.go('/Directions'), // Navigate to Directions
              child: const Text('Rental Dashboard'),
            ),

            */
            ElevatedButton(
              onPressed: () => context.go('/Interaction'), // Navigate to Directions
              child: const Text('Interaction'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/AnimatedRoute'), // Navigate to Directions
              child: const Text('AnimatedRoute'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/CircleLayer'), // Navigate to Directions
              child: const Text('CircleLayer'),
            ),
            /*ElevatedButton(
              onPressed: () => context.go('/UploadItem'), // Navigate to Directions
              child: const Text('UploadItem'),
            ),

            */
            ElevatedButton(
              onPressed: () => context.go('/UploadFirebase'), // Navigate to Directions
              child: const Text('FirebaseUpload'),
            )

          ],
        ),
      ),
    );
  }
}



/// The details screen
class DetailsScreen extends StatelessWidget {
  /// Constructs a [DetailsScreen]
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/'),
          child: const Text('Go back to the Home screen'),
        ),
      ),
    );
  }
}