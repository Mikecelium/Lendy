import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:io';

import 'package:turf/helpers.dart';

import 'package:flutter/foundation.dart';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show rootBundle;










const String ACCESS_TOKEN = 'pk.eyJ1IjoibWlrZW9sc2VuIiwiYSI6ImNsanllbjVybTAzYTczbHFnNGdxc2hoY2kifQ.w1MWWZd8X2Ofk1uKWFqhJA';

class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}



class FullMapState extends State<FullMap> {
  MapboxMap? mapboxMap;

  

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    mapboxMap.location.updateSettings(LocationComponentSettings(enabled: true));
    mapboxMap.location.updateSettings(LocationComponentSettings(pulsingEnabled: true));
    mapboxMap.setCamera(CameraOptions(
      center: Point(
          coordinates: Position(
        -0.11968,
        51.50325,
        0.0
      )).toJson()));



       await mapboxMap.style.addSource(GeoJsonSource(
        id: "source",
        data:
            "https://www.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson"));

       await mapboxMap.style.addLayer(HeatmapLayer(
        id: 'layer',
        sourceId: 'source',
        
        minZoom: 1.0,
        maxZoom: 20.0,
        
        heatmapColor: Colors.red.value,
        heatmapIntensity: 1.0,
        heatmapOpacity: 1.0,
        heatmapRadius: 1.0,
        heatmapWeight: 1.0,
        ));


//mapboxMap.loadStyleURI(MapboxStyles.TRAFFIC_NIGHT);


   



 



    

    


  }











  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapbox Example')),
      body: Stack(
        children: [
         MapWidget(
      key: const ValueKey("mapWidget"),
      resourceOptions: ResourceOptions(accessToken: ACCESS_TOKEN),
      onMapCreated: _onMapCreated,
         ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
        var status = await Permission.locationWhenInUse.request();
        print("Location granted : $status");
      },
              child: const Icon(Icons.location_on),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: FullMap()));
}











