import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class NaviUsers extends StatefulWidget {
  const NaviUsers({Key? key}) : super(key: key);

  @override
  _NaviUsersState createState() => _NaviUsersState();
}

class _NaviUsersState extends State<NaviUsers> {
  final CollectionReference userdata = FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffb4960f9),
        title: const Text("Users",
          style: TextStyle(fontSize: 18,),),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder(
          stream: userdata.snapshots(),
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
                    return Card (
                      child:
                        ListTile(
                          title: Text(
                              "${snapshot.data.docs[index]['userName']}"),
                          subtitle: Text(
                              "${snapshot.data.docs[index]['email']}"),
                          trailing: GestureDetector(
                            child: const CircleAvatar(
                              child: Icon(Icons.delete),
                            ),
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection("user")
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
