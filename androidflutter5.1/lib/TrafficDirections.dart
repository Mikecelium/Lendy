import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'GoRoutes.dart';

import 'package:go_router/go_router.dart';


import 'package:flutter/material.dart';

abstract class ExamplePage extends StatelessWidget {
  const ExamplePage(this.leading, this.title);

  final Widget leading;
  final String title;
}




class TrafficRouteLinePage extends ExamplePage {
  TrafficRouteLinePage()
      : super(const Icon(Icons.map), 'Style a route showing traffic');

  @override
  Widget build(BuildContext context) {
    return const RouteLine();
  }
}

class RouteLine extends StatefulWidget {
  const RouteLine();

  @override
  State createState() => RouteLineState();
}

class RouteLineState extends State<RouteLine> {
  late MapboxMap mapboxMap;
  final _sfAirport =
      Point(coordinates: Position(-122.39470445734368, 37.7080221537549));

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    final data = await rootBundle.loadString('assets/assets/sf_airport_route.geojson');
    await mapboxMap.style.addSource(GeoJsonSource(id: "line", data: data));
    await _addRouteLine();
  }

  _addRouteLine() async {
    await mapboxMap.style.addLayer(LineLayer(
      id: "line-layer",
      sourceId: "line",
      lineColor: Colors.black.value,
    ));
    // Defines a line-width, line-border-width and line-color at different zoom extents
    // by interpolating exponentially between stops.
    // Doc: https://docs.mapbox.com/style-spec/reference/expressions/
    await mapboxMap.style.setStyleLayerProperty(
        "line-layer",
        "line-width",
        '''
        ["interpolate", ["exponential", 1.5], ["zoom"],
        4.0, ["*", 6.0, 1.0],
        10.0, ["*", 7.0, 1.0],
        13.0, ["*", 9.0, 1.0],
        16.0, ["*", 13.0, 1.0],
        19.0, ["*", 17.0, 1.0],
        22.0, ["*", 21.0, 1.0]
        ]
        '''
            .trim()
            .replaceAll("\n", ""));
    await mapboxMap.style.setStyleLayerProperty(
        "line-layer",
        "line-border-width",
        '''
        ["interpolate", ["exponential", 1.5], ["zoom"],
        9.0, ["*", 1.0, 1.0],
        16.0, ["*", 3.0, 1.0]
        ]
        '''
            .trim()
            .replaceAll("\n", ""));
    await mapboxMap.style.setStyleLayerProperty(
        "line-layer",
        "line-color",
        '''
        ["interpolate", ["linear"], ["zoom"],
        8.0, "rgb(51, 102, 255)",
        11.0, ["coalesce", ["get", "route-color"], "rgb(51, 102, 255)"]
        ]
        '''
            .trim()
            .replaceAll("\n", ""));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const SizedBox(height: 10),
            ],
          ),
        ),

        body: Stack(




        children: [

         MapWidget(
          key: const ValueKey("mapWidget"),
          cameraOptions: CameraOptions(center: _sfAirport.toJson(), zoom: 11.0),
          textureView: true,
          onMapCreated: _onMapCreated,
          resourceOptions: ResourceOptions(accessToken: 'pk.eyJ1IjoibWlrZW9sc2VuIiwiYSI6ImNsanllbjVybTAzYTczbHFnNGdxc2hoY2kifQ.w1MWWZd8X2Ofk1uKWFqhJA'),
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
                  )
                  // Add more child buttons as needed
                ],
              ),
            ),
          )
        ]
        )
    );
  }
}










