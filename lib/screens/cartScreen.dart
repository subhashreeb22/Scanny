import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scanny/model/product_model.dart';
import 'package:scanny/screens/home_screen.dart';
import '../widgets/fetchdata.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}
class _CartScreenState extends State<CartScreen> {
  List _product = [];
  fetchProducts() async {
    QuerySnapshot qn =
    await FirebaseFirestore.instance.collection("product").get();
    setState(() {
      for(int i = 0; i < qn.docs.length; i++) {
         _product.add(
              {
                "productBarcode": qn.docs[i]["productBarcode"],
                "productName": qn.docs[i]["productName"],
                "productImage": qn.docs[i]["productImage"],
                "productPrice": qn.docs[i]["productPrice"],
              }
         );
      }
    });
      return qn.docs;
  }
/*  final CollectionReference productData = FirebaseFirestore.instance.collection("product");
  List<ProductModel> _productListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ProductModel(
        productBarcode: doc.get('productBarcode'),
        productName: doc.get('productName'),
        productImage: doc.get('productImage'),
        productPrice: doc.get('productPrice') ?? '',
      );
    }).toList();
  }
  Stream<List<ProductModel>> get productStream {
    return  productData.snapshots().map(_productListFromSnapshot);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffb4960f9),
        title: const Text("My Cart",
          style: TextStyle(fontSize: 18,),),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.logout),
            onPressed: () => logout(context),),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 90, bottom: 10),
        child: Row(
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
              backgroundColor: const Color(0xffb4960f9),
              label: const Text('Scan Again'),
            ),
            const SizedBox(width: 20,),
            FloatingActionButton.extended(
              onPressed: () {
                deleteAll();
                orders();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const CheckOutScreen()));
              },
              backgroundColor: Color(0xffb4960f9),
              label: const Text('Checkout'),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("user-cart-items")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("items")
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
             if (snapshot.hasError) {
                return const Center(
                    child: Text("Something is wrong"),
               );
              }
                  return ListView.builder(
                        itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
                         itemBuilder: (_, index) {
                            DocumentSnapshot cartSnapshots =
                               snapshot.data!.docs[index];
                           return CartCard(cartSnapshots : cartSnapshots);
                           });
                      },
      )

                );

          }
  void deleteAll() async {
    var collection = FirebaseFirestore.instance
        .collection("user-cart-items")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items");
    var snapshot = await collection.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
  Future orders() async {
    QuerySnapshot qn =
    await FirebaseFirestore.instance.collection("product").get();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionReference = FirebaseFirestore.instance
        .collection("orders");
    return _collectionReference.doc(currentUser!.email).collection("items").doc().set(
        {
          "productBarcode": ["productBarcode"],
          "productName": ["productName"],
          "productPrice": ["productPrice"],
        }).then((value) => print("Added to Orders"));
  }
}



