import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'RentalItem.dart'; // Your model class for rental items
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Listing.dart'; // Ensure this import points to your detail page
import 'package:go_router/go_router.dart';
import 'GoRoutes.dart';

class Nearby extends StatefulWidget {
  @override
  _RentalItemsListState createState() => _RentalItemsListState();
}

class _RentalItemsListState extends State<Nearby> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    initFirebase();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  Future<void> initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      print(e);
      print('Firebase error');
    }
  }

  Stream<List<RentalItem>> streamRentalItems() {
    return FirebaseFirestore.instance.collection('rentalItems').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return RentalItem.fromMap(doc.data() as Map<String, dynamic>);
      }).where((item) => searchQuery.isEmpty || item.title.toLowerCase().contains(searchQuery)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      body: Stack(
        children: [
          Image.asset('assets/images/LendyImage.png', width: 100, height: 100), // Use your asset image
  
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      hintText: 'Enter title',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.deepOrange),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<RentalItem>>(
                    stream: streamRentalItems(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("An error occurred!"));
                      } else if (!snapshot.hasData) {
                        return Center(child: Text("No data available"));
                      } else {
                        List<RentalItem> rentalItems = snapshot.data!;
                        return GridView.builder(
                          padding: EdgeInsets.all(20),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.0,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: rentalItems.length,
                          itemBuilder: (context, index) {
                            RentalItem item = rentalItems[index];
                            return InkWell(
                              onTap: () {
                                // Navigate to the RentalItemDetailPage with the selected item
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RentalItemDetailPage(rentalItem: item),
                                ));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                        child: (item.images.isNotEmpty)
                                            ? Image.network(item.images.first, fit: BoxFit.cover, width: double.infinity)
                                            : Container(color: Colors.grey.shade300), // Placeholder in case of no image
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(item.title, style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text("\$${item.rentalPrice} per day"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
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
          // Your Positioned widget with buttons
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}