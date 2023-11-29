import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scanny/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:scanny/screens/cartScreen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> entries  = [];
  String? barcodeScanRes;
  String? scanBarcode;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  Future<void> scanBarcodeNormal() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);

    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      scanBarcode = barcodeScanRes;
      entries.add(scanBarcode!);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffb4960f9),
        title: Text("Welcome, ${loggedInUser.userName}",
          style: const TextStyle(fontSize: 18,),),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.logout),
            onPressed: () => logout(context), ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 124, bottom: 10),
        child: Row(
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const CartScreen()));
              },
              backgroundColor: Color(0xffb4960f9),
              label: const Text('Cart'),
            ),
            const SizedBox(width: 20,),
            FloatingActionButton.extended(
              onPressed: () => scanBarcodeNormal(),
              backgroundColor: Color(0xffb4960f9),
              label: const Text('Scan'),
            ),
          ],
        ),
      ),
    body: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                  .collection("product")
                  .where("productBarcode", isEqualTo: '$barcodeScanRes')
                  .snapshots(),
                   builder: (context, snapshot) {
                     if (!snapshot.hasData) {
                       return Dialog(
                         child: Container(
                           height: 300,
                           child: const Text('Loading..', textAlign: TextAlign.center,),
                         ),
                       );
                     }
                     else if (snapshot.data!.docs.isEmpty) {
                       return Dialog(
                         child: Container(
                           height: 300,
                           child: const Text("Scan Again",textAlign: TextAlign.center,),
                         ),
                       );
                     }
                     else {
                       return Dialog(
                         child: Container(
                           height: 350,
                           child: Column(children: [
                             Container(
                                 height: 350,
                                 width: 165,
                                 child: ListView.builder(
                                   scrollDirection: Axis.horizontal,
                                   itemCount: snapshot.data!.docs.length,
                                   itemBuilder: (context, index) {
                                     DocumentSnapshot products = snapshot.data!
                                         .docs[index];
                                     return ScanCard(products: products);
                                   },
                                 )
                             ),
                           ]
                           ),
                         ),
                       );
                     }
                   }
        )
    );
   }
}

// the logout function
Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()));
}

class ScanCard extends StatelessWidget {
  const ScanCard({
    Key? key,
    required this.products,
  }) : super(key: key);
  final DocumentSnapshot products;
  Future addToCart() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionReference = FirebaseFirestore.instance
        .collection("user-cart-items");
     return _collectionReference.doc(currentUser!.email).collection("items").doc().set(
         {
           "productBarcode": products["productBarcode"],
            "productName": products["productName"],
            "productPrice": products["productPrice"],
         }).then((value) => print("Added to Cart"));
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          height: 180,
          width: 160,
          decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(16)),
          child: Image.network(products['productImage']),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
          child: Text("${
              products['productName']}",style: const TextStyle( color: Colors.blueGrey,fontSize: 18,),),),
        Row(
          children: [
            Text("Rs.${products['productPrice']}",style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            const SizedBox(width: 40,),
            const Icon(Icons.add_shopping_cart,color: Colors.black, size: 25, ),
          ],
        ),
        const SizedBox(width: 10,),
        SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                color: Colors.red,
                child: const Text("Add to cart", style: TextStyle(color: Colors.white),),
                onPressed: () {
                  addToCart();
                  Fluttertoast.showToast(msg: "${products['productName']} Added Successfully");
                },
              ),
            )
        )
      ],
    );
  }
}

