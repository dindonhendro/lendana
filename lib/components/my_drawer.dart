import 'package:flutter/material.dart';
import 'package:lendana5/components/my_list_tile.dart';
import 'package:lendana5/pages/login_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          //dreawer header
          DrawerHeader(
              child: Icon(
            Icons.shopping_bag,
            size: 72,
            color: Theme.of(context).colorScheme.inversePrimary,
          )),

          //shop tile
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyListTile(
                icon: Icons.home,
                text: 'Shop',
                onTap: () => Navigator.pop(context),
              ),
              MyListTile(
                icon: Icons.shopping_cart,
                text: 'Cart',
                onTap: () => Navigator.pushNamed(context, '/cart_page'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              icon: Icons.logout,
              text: 'Exit',
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              ),
            ),

            //cart tile
            //exit
          )
        ],
      ),
    );
  }
}
