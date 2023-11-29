import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NaviProducts extends StatefulWidget {
   const NaviProducts({Key? key}) : super(key: key);
  @override
  _NaviProductsState createState() => _NaviProductsState();
}

class _NaviProductsState extends State<NaviProducts> {
  final CollectionReference productData = FirebaseFirestore.instance.collection("product");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffb4960f9),
        title: const Text("Products",
          style: TextStyle(fontSize: 18,),),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder(
          stream: productData.snapshots(),
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
                    DocumentSnapshot _documentSnapshot =
                    snapshot.data!.docs[index];
                    return Card(
                      child:
                        ListTile(
                             leading: CircleAvatar(
                               backgroundImage: NetworkImage(
                                    snapshot.data.docs[index]['productImage']
                               ),
                              ),
                          title: Text(
                              "${snapshot.data.docs[index]['productName']}"),
                          subtitle: Text(
                              "Rs.${snapshot.data.docs[index]['productPrice']}"),
                          trailing: GestureDetector(
                            child: const CircleAvatar(
                              child: Icon(Icons.delete),
                            ),
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection("product")
                                  .doc(_documentSnapshot.id)
                                  .delete();
                            },
                          ),
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