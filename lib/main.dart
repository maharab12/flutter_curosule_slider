import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter is initialized.
  await Firebase.initializeApp(); // Initialize Firebase.
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Homepage(),
    );
  }
}
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<List<DocumentSnapshot>> getData() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection("country").get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: FutureBuilder(
        future: getData(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // You can show a loading indicator while data is being fetched.
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            List<DocumentSnapshot>? data = snapshot.data as List<DocumentSnapshot>?;
            return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (_, index) {
                DocumentSnapshot<Object?>? document = data?[index];
                final name = document?["Name"] as String?;
                return Card(
                  child: ListTile(
                    title: Text(name ?? 'No Name'), // Handle the possibility of a null name.
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
