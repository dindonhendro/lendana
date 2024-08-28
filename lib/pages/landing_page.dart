import 'package:flutter/material.dart';
import 'package:lendana5/jobfinder/screens/main_screen.dart';
import 'package:lendana5/pages/bank_page.dart';
import 'package:lendana5/pages/profile_page.dart';
import 'package:lendana5/pages/lengkapi_page.dart';
import 'package:lendana5/pages/logout_page.dart';

import 'package:lendana5/repository/api_repository.dart';

class LandingPage extends StatelessWidget {
  final Future<int?> userIdFuture = ApiRepository().getId();

  LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lendana'),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.logout),
          //     onPressed: () async {
          //       await ApiRepository().logout();
          //       Navigator.pushReplacementNamed(context, '/login');
          //       print('Logout button has been pressed');
          //     },
          //   )
          // ],
        ),
        body: FutureBuilder<int?>(
          future: userIdFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${snapshot.error}'),
                    ElevatedButton(
                      onPressed: () {
                        // Retry fetching the userId
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LandingPage(),
                          ),
                        );
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              final userId = snapshot.data!;
              return TabBarView(
                children: <Widget>[
                  MainScreen(),
                  LengkapiPage(userId: userId),
                  BankPage(
                    userId: userId,
                  ),
                  ProfilePage(userId: userId),
                ],
              );
            } else {
              return Center(
                child: Text('User ID not found'),
              );
            }
          },
        ),
        bottomNavigationBar: TabBar(
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home),
              text: 'Home',
            ),
            Tab(
              icon: Icon(Icons.person),
              text: 'Data',
            ),
            Tab(
              icon: Icon(Icons.money),
              text: 'Loan',
            ),
            Tab(
              icon: Icon(Icons.people),
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
