import 'package:flutter/material.dart';

import '../adminnavigation/navihome.dart';
import '../adminnavigation/naviorders.dart';
import '../adminnavigation/naviproducts.dart';
import '../adminnavigation/naviuser.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int pageIndex = 0;

  final pages = [
    const NaviHome(),
    const NaviProducts(),
    const NaviUsers(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xffb4960f9),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
              Icons.home_filled,
              color: Colors.white,
            )
                : const Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
              Icons.widgets_rounded,
              color: Colors.white,
            )
                : const Icon(
              Icons.widgets_outlined,
              color: Colors.white,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            icon: pageIndex == 2
                ? const Icon(
              Icons.person,
              color: Colors.white,
            )
                : const Icon(
              Icons.person_outline,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
