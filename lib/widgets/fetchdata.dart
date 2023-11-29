import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class CartCard extends StatelessWidget {
  const CartCard({Key? key, required this.cartSnapshots}) : super(key: key);
  final DocumentSnapshot cartSnapshots;
  Future addExtra() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionReference = FirebaseFirestore.instance
        .collection("user-cart-items");
    return _collectionReference.doc(currentUser!.email).collection("items").doc().set(
        {
          "productBarcode": cartSnapshots["productBarcode"],
          "productName": cartSnapshots["productName"],
          "productPrice": cartSnapshots["productPrice"],
        }).then((value) => print("Added to Cart"));
  }
  Future orderss() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionReference = FirebaseFirestore.instance
        .collection("orderss");
    return _collectionReference.doc(currentUser!.email).collection("items").doc().set(
        {
          "productBarcode": cartSnapshots["productBarcode"],
          "productName": cartSnapshots["productName"],
          "productPrice": cartSnapshots["productPrice"],
        }).then((value) => print("Added to Cart"));
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text("${
                      cartSnapshots['productName']}"),
                ),
                Expanded(
                  child: Text("Rs.${
                      cartSnapshots['productPrice']}"),
                ),
                IconButton(
                  onPressed: () {
                    addExtra();
                  },
                  icon: Icon(Icons.add_circle),
                ),
                IconButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("user-cart-items")
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .collection("items")
                        .doc(cartSnapshots.id)
                        .delete();
                  },
                  icon: Icon(Icons.remove_circle),
                ),
              ],
            ),
        ),
    );
  }
}
