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


import 'SelectedRental.dart';
















abstract class ExamplePage extends StatelessWidget {
  const ExamplePage(this.leading, this.title);

  final Widget leading;
  final String title;
}






bool _showBottomSheet = false;

// Function to search for additional information based on ID

String findAdditionalInfoById(int id) {
  
customDataList;

if (id >= 0 && id < customDataList.length) {
      return customDataList[id].description;
    } else {
      throw Exception('Index out of range');
    }
}




class CircleAnnotationPage extends ExamplePage {
  CircleAnnotationPage() : super(const Icon(Icons.map), 'Circle Annotations');

  @override
  Widget build(BuildContext context) {
    return const CircleAnnotationPageBody();


  }

  
}



//PAGE BODY CLASS


class CircleAnnotationPageBody extends StatefulWidget {
  const CircleAnnotationPageBody();

  @override
  State<StatefulWidget> createState() => CircleAnnotationPageBodyState();
  
}














//CUSTOM ANNOTATION EXTENSION







class CustomData {
  final List<String> urlList;
  final String description;
  final String title;
  final String identifier;
  final double price;
  final int id;
  // Assuming NewRental is a class you have defined elsewhere
  // final List<NewRental> rentalList;

  CustomData({
    required this.id,
    required this.urlList,
    required this.description,
    required this.title,
    required this.identifier,
    required this.price,
    // required this.rentalList,
  });

  // Asynchronous factory method to create CustomData instances.
  // I'm commenting out the parts that involve rentals to focus on fixing the syntax.
  static Future<CustomData> createWithRentalList({
    required int id,
    required List<String> urlList,
    required String description,
    required String title,
    required String identifier,
    required double price,
    // required List<DocumentReference> rentalRefs, // Assuming this is something you plan to use.
  }) async {
    // Here you would typically fetch or process your rental data.
    // For demonstration, I'm skipping that part.

    // Let's pretend we processed the rentals and have them ready.
    // List<NewRental> rentals = await fetchRentals(rentalRefs);

    return CustomData(
      id: id,
      urlList: urlList,
      description: description,
      title: title,
      identifier: identifier,
      price: price,
      // rentalList: rentals,
    );
  }

  // Placeholder for the fetchRentals method
  // This is just a placeholder. You'll need to implement the logic based on your requirements.
  // static Future<List<NewRental>> fetchRentals(List<DocumentReference> refs) async {
  //   // Fetch and process the rentals based on the refs
  //   return [];
   }



// Define a list to hold your additional data
List<CustomData> customDataList = [];





//ANNOTATION CLICK LISTENER CLASS




class AnnotationClickListener extends OnCircleAnnotationClickListener {
  final BuildContext context;

  final bool BottomSheetVisible = false;


  final Function(bool, CircleAnnotation)? toggleSheetVisibility;

  

  AnnotationClickListener(this.context, this.toggleSheetVisibility);

  @override
  void onCircleAnnotationClick(CircleAnnotation annotation) {
    if (true /*annotation is CustomCircleAnnotation*/) {
      print("Annotation clicked: ${customDataList[int.parse(annotation.id)].description}");

      toggleSheetVisibility!(true, annotation);

      annotation.circleStrokeWidth = 200;

      

    
    print(toggleSheetVisibility); // This should not print null

      

      
    }
  }
}



//MAIN CLASS



class CircleAnnotationPageBodyState extends State<CircleAnnotationPageBody> {
  CircleAnnotationPageBodyState();

late final StreamSubscription<QuerySnapshot> _locationsSubscription;

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

final TextEditingController searchController = TextEditingController();




  MapboxMap? mapboxMap;
  CircleAnnotation? circleAnnotation;
  CircleAnnotationManager? circleAnnotationManager;
  int styleIndex = 1;

  CircleAnnotationManager? annotationManager;

  

bool _showBottomSheet = false; 
void toggleBottomSheet(bool isVisible, [CircleAnnotation? annotation]) {
  setState(() {
    _showBottomSheet = isVisible;

    if (annotation != null) {
      // Do something with the annotation
    }

    if (isVisible) {
      _scaffoldKey.currentState?.showBottomSheet<void>((BuildContext context) {
        return Container(
          height: 220, // Adjusted height to accommodate the image slider
          width: MediaQuery.of(context).size.width - 30,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 140, // Height for the image slider
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: customDataList[int.parse(annotation!.id)].urlList.length,
                    itemBuilder: (BuildContext context, int index) {
                      String imageUrl = customDataList[int.parse(annotation.id)].urlList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          width: 180,
                          height: 140,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Stack(
                              alignment: Alignment.center, // Centers the progress indicator within the stack
                              children: <Widget>[
                                Image.network(
                                  imageUrl,
                                  width: 180,
                                  height: 140,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 140),
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child; // Image is fully loaded
                                    } else {
                                      return Container(
                                        width: 180,
                                        height: 140,
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(), // Show loading indicator
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 2), // Space after the image slider
                Expanded(
                  child: Text(
                    '\$${customDataList[int.parse(annotation.id)].price} + per day',
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
                // Inside the bottom sheet widget
SizedBox(
  height: 30,
  //width: 360, // Adjust the height to fit both buttons
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space out the buttons evenly
    children: [
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red, // Close button color
          ),
          child: const Text('Close'),
          onPressed: () {
            Navigator.pop(context); // Close the bottom sheet
            toggleBottomSheet(false, annotation); // Update visibility state
          },
        ),
      ),

      SizedBox(width: 20),
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green, // Rent button color
          ),
          child: const Text('Rent'),
          onPressed: () {
  // Retrieve the list of image URLs for the annotation
  String annotationIdentifier = customDataList[int.parse(annotation.id)].identifier;

  // Navigate to the new page and pass the list of image URLs
   Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RentalSelectionPage(annotationId: annotationIdentifier,),
      ),
    );
},
        ),
      ),
    ],
  ),
)
              ],
            ),
          ),
        );
      });
    }
  

  


  else
  {


    //Navigator.pop(context);






    /*
if (true) {
      
      _scaffoldKey.currentState?.showBottomSheet<void>((BuildContext context) {
        Navigator.pop(context);
        return Container(
          height: 210,
          width: MediaQuery.of(context).size.width - 30, // Adjusted height to fit content
          decoration: BoxDecoration(
            color: Colors.grey[900], // Darker background color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    SizedBox(width: 16), // Space between image and text
                    Expanded(
                      child: Text(
                        'no price to display',
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Button background color
                    onPrimary: Colors.white, // Button text color
                  ),
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                    toggleBottomSheet(false); // Update visibility state
                  },
                ),
                  ],
                ),
                SizedBox(height: 10), // Space between the row and the button
                
                ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        'https://staticg.sportskeeda.com/editor/2021/03/833f6-16171425884439.png',
                        width: 180, // Adjusted size
                        height: 180, // Adjusted size
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error, size: 140),
                      ),
                    ),
              ],
            ),
          ),
        );
      });
    }
*/


  }



  }
  
  );

  
}


 @override
  void initState() {
    super.initState();
    initFirebase();
    //printRentalItems("", context);
  }








  Future<void> initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      // Consider moving _subscribeToLocations call here if it depends on Firebase initialization
    } catch (e) {
      print(e);
      print('Firebase error');
    }
  }




































Future<void> addCircleAnnotationsFromFirestore(String searchQuery, context) async {


  try {

    // Ensure circleAnnotationManager is already initialized in _onMapCreated
  await circleAnnotationManager?.deleteAll(); // Clear existing annotations


    var options1 = <CircleAnnotationOptions>[];







    // Fetch documents from Firestore

    var snapshot = await FirebaseFirestore.instance.collection('rentalItems').get();









    var count = 0;

    for (var doc in snapshot.docs) {
      RentalItem item = RentalItem.fromMap(doc.data() as Map<String, dynamic>);
      

      


      if(searchQuery.isEmpty || item.title.toLowerCase().contains(searchQuery.toLowerCase())) {
        options1.add(CircleAnnotationOptions(
          
          //description: item.rentalPrice,
          geometry: Point(
            coordinates: Position(
              item.longitude, // Make sure longitude comes first
              item.latitude,
            ),
          ).toJson(),
          circleColor: Color.fromARGB(255, 22, 164, 224).value,
          circleBlur: 0.3,
          circleStrokeColor: Color.fromARGB(255, 108, 6, 209).value,

          circleStrokeWidth: 2,

          circleOpacity: 0.8,
          circleRadius: 7.0,
        ));

        customDataList.add(CustomData(
          id: count,
          urlList: item.images,
          title: item.title,
          description: item.description,
          identifier: item.id,
          price: item.rentalPrice,
          //rental_list: rentalList,
        ));
        

print('${count}' + item.title);
   
        count = count + 1;
      }
    }

    // Create circle annotations after all options have been added
    await circleAnnotationManager?.createMulti(options1);
    circleAnnotationManager?.addOnCircleAnnotationClickListener(AnnotationClickListener(context, toggleBottomSheet));

  } catch (e) {
    print("An error occurred: $e");
  }
}



void clearAnnotations() {
  circleAnnotationManager?.deleteAll();
}





















//ANNOTATIONS FROM FIREBASE
































































 @override
  void dispose() {
    // Dispose of the Firestore subscription when the widget is disposed
    _locationsSubscription.cancel();
    searchController.dispose();
    super.dispose();
  }
















































//ON MAP CREATED












  




  _onMapCreated(MapboxMap mapboxMap) async {

    // circleAnnotationManager?.addOnCircleAnnotationClickListener(
    // AnnotationClickListener(context, toggleBottomSheet),
    //  );



    this.mapboxMap = mapboxMap;

     //if (circleAnnotationManager == null) {
    circleAnnotationManager ??= await mapboxMap.annotations.createCircleAnnotationManager();
  //}



    mapboxMap.gestures.getSettings();
    mapboxMap.flyTo(
    CameraOptions(
      center: Point(coordinates: Position(152.5499978, -25.8833298)).toJson(),
        anchor: ScreenCoordinate(x: 0, y: 0),
        zoom: 3,
        bearing: 0,
        pitch: -80),
    MapAnimationOptions(duration: 3000, startDelay: 1000));
    await mapboxMap.style.setStyleURI('mapbox://styles/mapbox/dark-v11');

    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    //mapbox://styles/mikeolsen/clt4pmccm00cj01py6uha6pe3
    //mapbox://styles/mikeolsen/clqroal1700d101ob09k72y3z


_onStyleLoaded();

//createOneAnnotation();

addCircleAnnotationsFromFirestore('', context);

print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');
print('loaded');

//deleteAnnotations();





    const url = "https://www.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson";

  

  


  }




 













































    








  void _onStyleLoaded() async {
    await mapboxMap?.style.addSource(GeoJsonSource(
      id: "source",
      data: "https://www.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson"));

    





    await mapboxMap?.style.addLayer(HeatmapLayer(

      
      
      id: 'layer2', 
      
      sourceId: 'source',

      
      //visibility: visibleForTesting ,
      minZoom: 0.0,
      maxZoom: 8.0,
      //sourceLayer:,
    //heatmapColor: 2,
      heatmapIntensity: 1,
      //heatmapOpacity: 0.4,

      heatmapOpacity: 
                        
                        0.7,
                        
                        
                    
      heatmapRadius: 15,
      heatmapWeight: 0.2,
      
      ));


    
  }



  void createOneAnnotation() {

    circleAnnotationManager?.deleteAll();

    circleAnnotationManager?.create(CircleAnnotationOptions(
      geometry: Point(
          coordinates: Position(
        0.381457,
        6.687337,
      )).toJson(),
      circleColor: Color.fromARGB(255, 34, 215, 34).value,
      circleRadius: 100.0,
    ));
  }


  void deleteAnnotations() {

    circleAnnotationManager?.deleteAll();

    
  }


//BottomSheetVisible = false; 

@override
  Widget build(BuildContext context) { 

    
    
    final MapWidget mapWidget = MapWidget(
      key: ValueKey("mapWidget"),
      onMapCreated: _onMapCreated,
      resourceOptions: ResourceOptions(
        accessToken: 'pk.eyJ1IjoibWlrZW9sc2VuIiwiYSI6ImNsanllbjVybTAzYTczbHFnNGdxc2hoY2kifQ.w1MWWZd8X2Ofk1uKWFqhJA',
      ),
    );

    //_showBottomSheet = true;

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(  
        children: [
          mapWidget,
          Positioned(
          top: MediaQuery.of(context).padding.top + 20,
          left: 45,
          right: 45,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            
            child: TextField(


            
              controller: searchController,
 



              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
              onSubmitted: (value) {

              _showBottomSheet = false;

              toggleBottomSheet(false);

                addCircleAnnotationsFromFirestore(value, context);
                print(value);
                print(value);
                print(value);
                print(value);
                print(value);
                print(value);
                print(value);
                print(value);
                print(value);
                print(value);
                print(value);
                print(value);
                print(value);
                print(value);
                print(value);
                print(value);
                print(value);
                print(value);
                print(value);
                print(value);
              },
            ),
            
          ),
          
        ),






































// AnimatedContainer(
//             duration: Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//             //height: _showBottomSheet ? MediaQuery.of(context).size.height - 500 : 0,
            
//             height: _showBottomSheet ? 50 : 70,
            
//             margin: EdgeInsets.only(top: _showBottomSheet ? MediaQuery.of(context).size.height - 270 : MediaQuery.of(context).size.height -100 ),
//             child: SingleChildScrollView(
//     child: Column(
//       children: [
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Padding(
//                     padding: EdgeInsets.only(bottom: 0), // Adjust the padding to move the button up
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Example route navigation
//                         context.go('/desiredRoute');
//                       },
//                       child: Text('Go!'),
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.blue.withOpacity(0.7), // Partially transparent
//                         onPrimary: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
          
        
//         // Any other elements in your stack...
//        Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 padding: const EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                   color: Color.fromARGB(255, 34, 27, 15),
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       spreadRadius: 0,
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     ElevatedButton(
//                       onPressed: () => context.go('/'),
//                       child: Text('Main'),
//                       style: ElevatedButton.styleFrom(
//                         primary: Color.fromARGB(255, 5, 54, 72),
//                         onPrimary: Colors.blue,
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => context.go('/Lendy'),
//                       child: Text('Lendy'),
//                       style: ElevatedButton.styleFrom(
//                         primary: Color.fromARGB(255, 5, 54, 72),
//                         onPrimary: Colors.blue,
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => context.go('/Map'),
//                       child: Text('Map'),
//                       style: ElevatedButton.styleFrom(
//                         primary: Color.fromARGB(255, 5, 54, 72),
//                         onPrimary: Colors.blue,
//                       ),
//                     ),


                    
//                   ],
//                 ),



        
                
//               ),
//             ),

//               ]
//           ),
        
        
//             ),
//           )
//         ]

//       ),
//     );
//   }
// }











       
AnimatedContainer(    
  duration: Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  //height: _showBottomSheet ? MediaQuery.of(context).size.height - 500 : 0,
  height: _showBottomSheet ? 120 : 140,
  margin: EdgeInsets.only(
    top: _showBottomSheet ? MediaQuery.of(context).size.height - 320 : MediaQuery.of(context).size.height - 140,
  ),
  padding: _showBottomSheet ? EdgeInsets.only(bottom: 0) : EdgeInsets.only(bottom: 20),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [  
      SizedBox(
        width: 200, // Specify the width here
        height: 35, // Specify the height here
        child: ElevatedButton(
          onPressed: () {
            // Example route navigation
            context.go('/FirestoreUploadImages');
          },
          child: FittedBox( // Use FittedBox to scale down content if necessary
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Rent Something!  '),
                Icon(Icons.library_add_check),
              ]
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue.withOpacity(0.45),
            onPrimary: Colors.white, 
          ),
        ),
      ),
      SizedBox(height: 15), // Space between "Go" button and the row
      
      
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     ElevatedButton(
      //       onPressed: () => context.go('/'),
      //       child: Text('Main'),
      //     ),
      //     ElevatedButton(
      //       onPressed: () => context.go('/Lendy'),
      //       child: Text('Lendy'),
      //     ),
      //     ElevatedButton(
      //       onPressed: () => context.go('/Map'),
      //       child: Text('Map'),
      //     ),
      //   ],
      // ),

SizedBox(  
        height: 40,
        width: 640,
        child:
Positioned(    
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(  
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 34, 27, 15),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),

                
                child: SizedBox(  
        height: 30,
        child:
                
                Row(

                  
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => context.go('/'),
                      child: Text('Main'),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 5, 54, 72),
                        onPrimary: Colors.blue,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.go('/Lendy'),
                      child: Text('Lendy'),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 5, 54, 72),
                        onPrimary: Colors.blue,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => context.go('/Map'),
                      child: Text('Map'),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 5, 54, 72),
                        onPrimary: Colors.blue,
                      ),
                    ),


                    
                  ],
                ),

                )
                )
                )
)
                ]
                )
                )
                ]
                )
                );
                }
}

