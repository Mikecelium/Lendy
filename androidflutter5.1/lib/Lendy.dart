import 'package:androidflutter/main.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'main.dart';
import 'GoRoutes.dart';




class Lendy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Stack(

        children: [
        
       ListView(
  padding: const EdgeInsets.all(30.0),
  children: <Widget>[
    Image.asset('assets/images/LendyImage.png', width: 100, height: 100), // Use your asset image
  
    SizedBox(height: 20),
    _buildButton(context, 'Post New Listing', '/postNewListing'),
    SizedBox(height: 40), // Spacing between buttons
    _buildButton(context, 'Pending Requests', '/pendingRequests'),
    SizedBox(height: 40), // Spacing between buttons
    _buildButton(context, 'Upcoming Lends', '/upcomingLends'),
    SizedBox(height: 40), // Spacing between buttons
    _buildButton(context, 'Current Lends', '/currentLends'),
    SizedBox(height: 40), // Spacing between buttons
    _buildButton(context, 'All Listings', '/allListings'),
  ],
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
                    onPressed: () => context.go('/Nearby_Listings'), // Navigate to home screen
                    child: Text('Search'),
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
                  // Add more child buttons as needed
                ],
              ),
            ),
          )
      ]
    ),
    );
  }


  Widget buildImage(BuildContext context) {
  return Image.asset('assets/images/LendyImage.png');

  
}

  Widget _buildButton(BuildContext context, String title, String route) {
  return GestureDetector(
    onTap: () => context.go(route),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.yellow.shade600, Colors.yellow.shade200],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(5, 10), // Changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.image, color: Colors.black), // Adjust icon color as needed
          SizedBox(width: 10, height: 10),
          Text(
            title,
            style: TextStyle(
              color: Colors.black, // Text color
            ),
          ),
        ],
      ),
    ),
  );
}
}

class PostNewListingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post New Listing')),
      body: Center(child: Text('This is the Post New Listing page')),
    );
  }
}

class PendingRequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pending Requests')),
      body: Center(child: Text('This is the Pending Requests page')),
    );
  }
}

class UpcomingLendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upcoming Lends')),
      body: Center(child: Text('This is the Upcoming Lends page')),
    );
  }
}

class CurrentLendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Current Lends')),
      body: Center(child: Text('This is the Current Lends page')),
    );
  }
}

class AllListingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Listings')),
      body: Center(child: Text('This is the All Listings page')),
    );
  }
}