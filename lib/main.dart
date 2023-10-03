import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future get() async {
    var s = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await s.collection("curosure_image").get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: FutureBuilder(
                future: get(),
                builder: (_, snapshot) {
                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return Center(
                  //     child: CircularProgressIndicator(),
                  //   );
                  // } else if (snapshot.hasError) {
                  //   return Center(
                  //     child: Text('Error: ${snapshot.error}'),
                  //   );
                  // } else {
                  List<QueryDocumentSnapshot> documents =
                      snapshot.data as List<QueryDocumentSnapshot>;

                  // if (documents.isEmpty) {
                  //   return Center(
                  //     child: Text('No images available.'),
                  //   );
                  // }

                  return CarouselSlider.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index, realIndex) {
                      // Get the image URL from the "img" field of the document
                      String imageUrl = documents[index].get("img") as String;

                      return Container(
                        child: Image.network(imageUrl),
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      //   enlargeCenterPage: true,
                      //   aspectRatio: 16 / 9,
                      //   // Adjust to the aspect ratio of your images
                      //   enableInfiniteScroll: true,
                      //   // Whether to loop the images
                      //   viewportFraction: 0.8,
                      //   // Portion of the visible area
                      //   onPageChanged: (index, reason) {
                      //     // This function is called when the page changes (indicator dots).
                      //     // You can add your own logic here if needed.
                      //   },
                      //   scrollDirection: Axis
                      //       .horizontal, // Change to Axis.vertical for vertical scrolling
                    ),
                  );
                })));
  }
}
