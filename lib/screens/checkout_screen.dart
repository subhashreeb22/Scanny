import 'package:flutter/material.dart';

import 'home_screen.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffb4960f9),
        title: const Text("Payment",
          style: TextStyle(fontSize: 18,),),
        centerTitle: true,
      ),
      floatingActionButton:FloatingActionButton.extended(
        onPressed: () => logout(context),
        backgroundColor: const Color(0xffb4960f9),
        label: const Text("LogOut"),
           ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               SizedBox(
               height: 130,
               child: Image.asset(
                 "assets/images/Confirmation.png",
                 fit: BoxFit.contain,
               )),
               Container(
                 padding: const EdgeInsets.all(30),
                 child: const SizedBox(
                   child: Text('Payment Successful ! Collect Your Order at the Counter.',
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xffb4960f9),
                   ),),
                 ),
               ),
             ],
           ),
        ),
      ),

    );
  }
}
