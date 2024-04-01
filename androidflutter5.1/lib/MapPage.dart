import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

//import 'package:flutter/widgets.dart.dart';

import 'main.dart';

import 'HomePage.dart';

import 'NotUsed/Nearby_Listings.dart';

import 'GoRoutes.dart';

import 'package:turf/helpers.dart';

import 'package:flutter/foundation.dart';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:go_router/go_router.dart';



/*


class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({Key? key, required this.router}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      title: 'Nested Buttons Navigation',
    );
  }
}






















const String ACCESS_TOKEN = 'pk.eyJ1IjoibWlrZW9sc2VuIiwiYSI6ImNsanllbjVybTAzYTczbHFnNGdxc2hoY2kifQ.w1MWWZd8X2Ofk1uKWFqhJA';



class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}



class FullMapState extends State<FullMap> {

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _bottomPadding = 0; // Initial padding from the bottom




  MapboxMap? mapController;

  bool showTransparentBox = false;
  Rect transparentBoxRect = Rect.zero;







    

@override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: MapWidget(), // Placeholder for your map widget
          ),
          Positioned(
            bottom: _bottomPadding, // Adjust based on bottom sheet height
            right: 20,
            child: FloatingActionButton(
              onPressed: _showFeaturesModal,
              child: Icon(Icons.list),
            ),
          ),
        ],
      ),
    );
  }
}

class MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder for a map widget
    return Container(color: Colors.blue);
  }
}



  _onTap(ScreenCoordinate coordinate) async {
  // Assuming you have latitude and longitude from the coordinate or another way to get them
  //Point point = await mapController?.scree ?? Point.longitude;
  //num latitude = point.coordinates.lat;
  //num longitude = point.coordinates.lng;

  // Define a padding around the tap location to create a small rectangular area
  const double padding = 10.0;
  Rect rect = Rect.fromLTWH(
    coordinate.x - padding,
    coordinate.y - padding,
    padding * 2,
    padding * 2,
  );

  // Query for features within the specified area and layer
  


  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Tapped at: Lat: ${coordinate.x}, Long: ${coordinate.y}"),
      duration: Duration(seconds: 2),
    ),
  );
}

  _onLongTap(ScreenCoordinate coordinate) {
    print("OnLongTap ${coordinate.x} - ${coordinate.y}");
  }

  _onMove(ScreenCoordinate coordinate) {
    print("OnMove ${coordinate.x} - ${coordinate.y}");
  }


  void _onMapCreated(MapboxMap mapcontroller) async {

    mapController?.gestures.getSettings();
    

    mapController = mapcontroller;
    mapController?.flyTo(
    CameraOptions(
      center: Point(coordinates: Position(152.5499978, -25.8833298)).toJson(),
        anchor: ScreenCoordinate(x: 0, y: 0),
        zoom: 3,
        bearing: 0,
        pitch: -80),
    MapAnimationOptions(duration: 3000, startDelay: 1000));
    await mapController?.style.setStyleURI('mapbox://styles/mikeolsen/clqroal1700d101ob09k72y3z');
    
    _onStyleLoaded();
    mapController?.location.updateSettings(LocationComponentSettings(

      

      enabled: true,
      
      locationPuck: LocationPuck(
        
        
          locationPuck3D: LocationPuck3D(
            modelScale: [0.1, 0.5, 0.3],
              modelUri:
                  "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf",))));
  }




  void toggleTransparentBox(ScreenBox screenBox) {
    // Convert ScreenBox coordinates to a Rect for positioning the widget
    setState(() {
      showTransparentBox = true;
      transparentBoxRect = Rect.fromPoints(
        Offset(screenBox.min.x, screenBox.min.y),
        Offset(screenBox.max.x, screenBox.max.y),
      );
    });

    // Hide the transparent box after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showTransparentBox = false;
      });
    });
    }



  void _onStyleLoaded() async {
    await mapController?.style.addSource(GeoJsonSource(
      id: "source",
      data: "https://www.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson"));

    

/*
    await mapController?.style.addLayer(HeatmapLayer(
      id: 'layer',
      sourceId: 'source',
      minZoom: 2.0,
      maxZoom: 5.0,
      heatmapColor: Color.fromARGB(255, 25, 42, 195).value,
      heatmapIntensity: 0.5,
      heatmapOpacity: 0.5,
      heatmapRadius: 0.1,
      heatmapWeight: 0.8,
    ));

    */

    await mapController?.style.addLayer(CircleLayer(
      id: 'layer1',
      sourceId: 'source',
      minZoom: 0.0,
      maxZoom: 20.0,
      circleColor: Color.fromARGB(255, 221, 153, 17).value,
      circleRadius: 7.5,
      circleOpacity: 0.8,
      circleStrokeColor: Color.fromARGB(175, 255, 239, 15).value,
      circleBlur: 0.5,
      circleStrokeWidth: 0.4,
    ));


    await mapController?.style.addLayer(LineLayer(
      id: "line_layer",
      sourceId: "source",
      lineJoin: LineJoin.ROUND,
      lineCap: LineCap.ROUND,
      lineOpacity: 0.7,
      lineColor: Color.fromARGB(255, 211, 22, 202).value,
      lineWidth: 8.0));


      mapController?.style.setStyleLayerProperty("layer", "line-gradient",
      ["interpolate",["linear"],["line-progress"],0.0,["rgb",6,1,255],0.5,["rgb",0,255,42],0.7,["rgb",255,252,0],1.0,["rgb",255,30,0]]);

  }


Widget _queryRenderedFeatures() {
    return TextButton(
      child: Text('queryRenderedFeatures'),
      onPressed: () {

        
        var screenBox = ScreenBox(
            min: ScreenCoordinate(x: 0.0, y: 0.0),
            max: ScreenCoordinate(x: 150.0, y: 510.0));

           
  // Other logic...

  // Show the transparent box
        toggleTransparentBox(screenBox);
        var renderedQueryGeometry = RenderedQueryGeometry(
            value: json.encode(screenBox.encode()), type: Type.SCREEN_BOX);
        mapController
            ?.queryRenderedFeatures(
                renderedQueryGeometry,
                RenderedQueryOptions(
                    layerIds: ['layer1', 'points'], filter: null))
            .then((value) =>
                showModalBottomSheet(



_scaffoldKey.currentState?.showBottomSheet<void>(
        // You can calculate the height of the bottom sheet content dynamically
        double bottomSheetHeight = 400; // Example height
        
        
        setState(() {
          _bottomPadding = bottomSheetHeight; // Adjust bottom padding to push up the overlay elements
        });

        return Container(
        height: 400, // Adjust height according to your needs
        child: ListView.builder(
          itemCount: value.length,
          itemBuilder: (BuildContext context, int index) {
            var element = value[index];
            // Assuming the feature object has a 'properties' map with a 'name' field you want to display
            // Adjust the key according to the actual structure of your GeoJSON features
            var featureName = element;
            return ListTile(
              title: Text(element!.feature.toString())
              // You can add more details or an onTap handler here
            );
          },
        ),
      );
      },
    ).closed.then((value) {
      // Reset bottom padding when the bottom sheet is closed
      if (_bottomPadding != 0) {
        setState(() {
          _bottomPadding = 0;
        });
      }
    });
  }






    


  Widget _getGestureSettings() {
    return TextButton(
      child: Text('get gesture settings'),
      onPressed: () {
        mapController?.gestures.getSettings().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("""
                  Gesture settings : 
                    doubleTapToZoomInEnabled : ${value.doubleTapToZoomInEnabled}, 
                    doubleTouchToZoomOutEnabled : ${value.doubleTouchToZoomOutEnabled}
                    focalPoint : ${value.focalPoint}
                    increasePinchToZoomThresholdWhenRotating : ${value.increasePinchToZoomThresholdWhenRotating}
                    increaseRotateThresholdWhenPinchingToZoom : ${value.increaseRotateThresholdWhenPinchingToZoom}
                    pinchPanEnabled : ${value.pinchPanEnabled}
                    pinchToZoomDecelerationEnabled :  ${value.pinchToZoomDecelerationEnabled},
                    quickZoomEnabled :  ${value.quickZoomEnabled}
                    rotateEnabled : ${value.rotateEnabled}
                    """
                      .trim()),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Stack(




        children: [

          

        


          
          
         MapWidget(
      key: const ValueKey("mapWidget"),
      resourceOptions: ResourceOptions(accessToken: ACCESS_TOKEN),

      onTapListener: _onTap,

      onLongTapListener: _onLongTap,

      


     
      onMapCreated: _onMapCreated,
      
         ),
          Positioned(
            
            bottom: 100,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
        var status = await Permission.locationWhenInUse.request();
        print("Location granted : $status");
      },
              child: const Icon(Icons.location_on),
            ),
          ),
          
          Positioned(
            bottom: 20, // Adjust this value to move the button up or down
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20), // Side margins
              padding: const EdgeInsets.all(15), // Inner padding
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 87, 65, 5), // Button color
                borderRadius: BorderRadius.circular(30), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: Offset(0, 2), // Changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => context.go('/'), // Navigate to home screen
                    child: Text('Nearby_Listings'),
                    style: ElevatedButton.styleFrom(primary: Colors.white, onPrimary: Colors.blue),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go('/Lendy'), // Navigate to marketplace
                    child: Text('Lendy'),
                    style: ElevatedButton.styleFrom(primary: Colors.white, onPrimary: Colors.blue),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go('/Map'), // Navigate to marketplace
                    child: Text('Map'),
                    style: ElevatedButton.styleFrom(primary: Colors.white, onPrimary: Colors.blue),
                  ),
                  _getGestureSettings(),
                  _queryRenderedFeatures()
                  // Add more child buttons as needed
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 70, // Adjust this value to move the button up or down
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20), // Side margins
              padding: const EdgeInsets.all(15), // Inner padding
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 87, 65, 5), // Button color
                borderRadius: BorderRadius.circular(30), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: Offset(0, 2), // Changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  
                  _getGestureSettings(),
                  _queryRenderedFeatures()
                  // Add more child buttons as needed
                ],
              ),
            ),
          ),
          if (showTransparentBox)
          Positioned.fromRect(
            rect: transparentBoxRect,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
            ),
          )

        ],
      ),
    );
  }









  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: MapWidget(), // Placeholder for your map widget
          ),
          Positioned(
            bottom: _bottomPadding, // Adjust based on bottom sheet height
            right: 20,
            child: FloatingActionButton(
              onPressed: _showFeaturesModal,
              child: Icon(Icons.list),
            ),
          ),
        ],
      ),
    );
  }
}

class MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder for a map widget
    return Container(color: Colors.blue);
  }
}








*/