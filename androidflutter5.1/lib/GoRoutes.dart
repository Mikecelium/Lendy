// app_router.dart
import 'package:androidflutter/CircleLayer.dart';
import 'package:androidflutter/Lendy.dart';
import 'package:go_router/go_router.dart';


import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart.dart';
import 'main.dart';
import 'HomePage.dart';
import 'NotUsed/Nearby_Listings.dart';

import 'Interaction.dart';

import 'AnimatedRoute.dart';

import 'UploadListing.dart';


import 'package:turf/helpers.dart';

import 'package:flutter/foundation.dart';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:go_router/go_router.dart';




import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import 'HomePage.dart';
import 'NotUsed/Authentication.dart';
import 'NotUsed/Nearby_Listings.dart';
import 'NotUsed/Calendar.dart';
import 'FlutterCalendar.dart';

import 'CircleLayer.dart';

import 'TrafficDirections.dart';

import 'Lendy.dart';

import 'NotUsed/RentalItemListing.dart';

import 'NearbyListings.dart';

import 'UploadFirebase.dart';

import 'FirebaseCopy.dart';

import 'FirebaseUpload.dart';

import 'FirebaseUploadImages.dart';

import 'FirebaseUploadComments.dart';



import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final GoRouter appRouter = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/Map',
      builder: (context, state) => FullMap(),
    ),
    GoRoute(
      path: '/Nearby_Listings',
      builder: (context, state) => Nearby(),
    ),
     GoRoute(
      path: '/Authentication',
      builder: (context, state) => Authentication(),
    ),
     GoRoute(
      path: '/MarketplacePage',
      builder: (context, state) => MarketplacePage(),
    ),
     GoRoute(
      path: '/Calendar',
      builder: (context, state) => SyncCalendar(),
    ),
      GoRoute(
      path: '/rentalItems',
      builder: (context, state) => RentalItemsList(),
    ),
      GoRoute(
      path: '/Lendy',
      builder: (context, state) => Lendy(),
    ),
      GoRoute(
      path: '/Directions',
      builder: (context, state) => TrafficRouteLinePage(),
    ),


//Page for Lendy


      GoRoute(
      path: '/postNewListing',
      builder: (BuildContext context, state) => PostNewListingPage(),
    ),
    
      GoRoute(
      path: '/pendingRequests',
      builder: (BuildContext context, state) => PendingRequestsPage(),
    ),

      GoRoute(
      path: '/upcomingLends',
      builder: (BuildContext context, state) => UpcomingLendsPage(),
    ),

      GoRoute(
      path: '/currentLends',
      builder: (BuildContext context, state) => CurrentLendsPage(),
    ),

      GoRoute(
      path: '/allListings',
      builder: (BuildContext context, state) => AllListingsPage(),
    ),
      GoRoute(
      path: '/Interaction',
      builder: (BuildContext context, state) => InterfacePage(),
    ),
      GoRoute(
      path: '/AnimatedRoute',
      builder: (BuildContext context, state) => AnimatedRoutePage1(),
    ),
     GoRoute(
      path: '/CircleLayer',
      builder: (BuildContext context, state) => CircleAnnotationPage(),
    ),

    GoRoute(
      path: '/UploadFirebase',
      builder: (BuildContext context, state) => DescriptionUploadPage(),
    ),

    GoRoute(
      path: '/FirestoreCopy',
      builder: (BuildContext context, state) => CopyFirestoreDoc(),
    ),


     GoRoute(
      path: '/FirestoreUpload',
      builder: (BuildContext context, state) => UploadFirestoreDoc(),
    ),

     GoRoute(
      path: '/FirestoreUploadImages',
      builder: (BuildContext context, state) => ImageUploadPage(),
    ),

    GoRoute(
  path: '/FirestoreUploadComments',
  builder: (BuildContext context, GoRouterState state) {
    // Assuming you're passing the document ID as an extra parameter
    final documentId = state.extra as String; // Cast it to the correct type
    return UploadCommentsPage(documentId: documentId); // Pass it to your page
  },
),








    
    /* GoRoute(
      path: '/UploadItem',
      builder: (BuildContext context, state) => UploadItemPage(),
    ),
    */




    ],
  );




