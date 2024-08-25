import 'package:flutter/material.dart';
import 'package:lendana5/components/my_button.dart';
import 'package:lendana5/pages/docs.dart/doc_page.dart';
import 'package:lendana5/pages/foto_page.dart';
import 'package:lendana5/pages/user_page.dart';
import 'package:lendana5/pages/user_page1.dart';

class LengkapiPage extends StatefulWidget {
  final int userId;

  LengkapiPage({required this.userId});

  @override
  State<LengkapiPage> createState() => _LengkapiPageState();
}

class _LengkapiPageState extends State<LengkapiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: Text(
                  'Lengkapi profil Anda',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              MyButton(
                width: 250, // Set your desired width
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FotoPage(userId: widget.userId)),
                  );
                },
                child: Text('Unggah Foto Diri'),
              ),
              SizedBox(height: 10),
              MyButton(
                width: 250, // Set your desired width
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserPage(userId: widget.userId)),
                  );
                },
                child: Text('Data Pribadi'),
              ),
              SizedBox(height: 10),
              MyButton(
                width: 250, // Set your desired width
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserPage1(userId: widget.userId)),
                  );
                },
                child: Text('Data Pendukung'),
              ),
              SizedBox(height: 10),
              MyButton(
                width: 250, // Set your desired width
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DocPage(userId: widget.userId)),
                  );
                },
                child: Text('Unggah KTP / NIK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
