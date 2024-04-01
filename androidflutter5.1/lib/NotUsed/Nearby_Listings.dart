import 'package:flutter/material.dart';


class Listing {
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  Listing({required this.title, required this.description, required this.price, required this.imageUrl});
}

class Listing_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marketplace Listings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MarketplacePage(),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Listing listing;

  DetailPage({required this.listing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listing.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(listing.imageUrl, fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  listing.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  '\$${listing.price}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MarketplacePage extends StatefulWidget {
  @override
  _MarketplacePageState createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  

  List<Listing> listings = [
  Listing(
    title: 'Vintage Chair',
    description: 'A nice vintage chair',
    price: 50.0,
    imageUrl: 'https://i.etsystatic.com/10821213/r/il/1a23d4/4010463671/il_1140xN.4010463671_m0m4.jpg',
  ),
  Listing(
    title: 'Bicycle',
    description: 'Mountain bike in good condition',
    price: 120.0,
    imageUrl:  'https://bicyclingaustralia.com.au/wp-content/uploads/2023/03/WBR_The_Bike3-1-1600x1180.jpg',
  ),
  Listing(
    title: 'Designer Lamp',
    description: 'Modern design lamp for your desk',
    price: 35.0,
    imageUrl: 'https://i.etsystatic.com/7279722/r/il/5bb9e1/5075312626/il_570xN.5075312626_cmgb.jpg',
  ),
  Listing(
    title: 'Coffee Table',
    description: 'Wooden coffee table, excellent condition',
    price: 80.0,
    imageUrl: 'https://kingstonfurniture.com.au/wp-content/uploads/2023/11/ILA001-Reclaimed-Timber-Jacob-Coffee-Table-1.webp',
  ),
  Listing(
    title: 'Guitar',
    description: 'Acoustic guitar, barely used',
    price: 100.0,
    imageUrl: 'https://i.ebayimg.com/images/g/uk8AAOSw~gplGH1o/s-l1600.jpg',
  ),
  Listing(
    title: 'Running Shoes',
    description: 'Brand new running shoes, size 10',
    price: 60.0,
    imageUrl: 'https://img.kwcdn.com/product/open/2023-06-02/1685719793723-9aac3245efe34d638ed2bb9e4db54a2e-goods.jpeg?imageView2/2/w/800/q/70',
  ),
  Listing(
    title: 'Backpack',
    description: 'Durable hiking backpack',
    price: 45.0,
    imageUrl: 'https://www.thewanderingqueen.com/wp-content/uploads/2021/11/Best-Hiking-Backpack-For-Women-2-of-1.jpg',
  ),
  Listing(
    title: 'Surfboard',
    description: 'Midlength Surfboard',
    price: 150.0,
    imageUrl: 'https://boardsinthebay.com.au/cdn/shop/files/image_c20e4a8a-e395-4e5c-8607-851f91ff1833.jpg?v=1685748519',
  ),
  Listing(
    title: 'Bookshelf',
    description: 'Large bookshelf with plenty of storage',
    price: 90.0,
    imageUrl: 'https://www.dshop.com.au/assets/full/XS4-O.jpg?20220214211214',
  ),
];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    List<Listing> filteredListings = listings
        .where((listing) =>
            listing.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            listing.description.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Marketplace Listings'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
  itemCount: filteredListings.length,
  itemBuilder: (context, index) {
    final listing = filteredListings[index];
    return ListTile(
      leading: Image.network(
        listing.imageUrl,
        width: 50, // Set the width of the image
        height: 50, // Set the height of the image
        fit: BoxFit.cover, // Cover the area without changing the aspect ratio
      ),
      title: Text(listing.title),
      subtitle: Text(listing.description),
      trailing: Text('\$${listing.price}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailPage(listing: listing)),
        );
      },
    );
  },
),
          ),
        ],
      ),
    );
  }
}