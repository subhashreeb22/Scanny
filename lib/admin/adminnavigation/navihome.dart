import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/login_screen.dart';

class NaviHome extends StatefulWidget {
  const NaviHome({Key? key}) : super(key: key);

  @override
  _NaviHomeState createState() => _NaviHomeState();
}

class _NaviHomeState extends State<NaviHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffb4960f9),
        title: const Text("Welcome, Admin",
          style: TextStyle(fontSize: 18,),),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.logout),
            onPressed: () => logout(context), ),
        ],
      ),
        body:  Container(
              child: const Center(
                    child: Text(
                   "Welcome, Admin to Scanny App",
                        style: TextStyle(
                             color: Color(0xffb4960f9),
                        fontSize: 20,
                         fontWeight: FontWeight.w500,
                   ),
                  ),
             ),
         ),
    );
  }
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
