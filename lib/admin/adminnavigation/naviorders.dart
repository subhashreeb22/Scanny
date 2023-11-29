import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NaviOrders extends StatefulWidget {
  const NaviOrders({Key? key}) : super(key: key);

  @override
  _NaviOrdersState createState() => _NaviOrdersState();
}

class _NaviOrdersState extends State<NaviOrders> {
  final CollectionReference orderdata = FirebaseFirestore.instance
      .collection("user-cart-items")
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection("items");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffb4960f9),
        title: const Text("Orders",
          style: TextStyle(fontSize: 18,),),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder(
          stream: orderdata.snapshots(),
          builder:(context, AsyncSnapshot snapshot) {
            if(snapshot.hasError) {
              return Text("Error: ${snapshot.hasError}");
            }
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading..");
            }
            if(snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child:
                      ListTile(
                        title: Text(
                            "${snapshot.data.docs[index]['productName']}"),
                        subtitle: Text(
                            "Rs.${snapshot.data.docs[index]['productPrice']}"),
                      ),

                    );
                  }
              );
            }
            return const Text("Loading");
          },
        ),
      ),
    );
  }

}
