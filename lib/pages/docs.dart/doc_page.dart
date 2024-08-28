import 'package:flutter/material.dart';
import 'package:lendana5/components/my_button.dart';
import 'package:lendana5/pages/docs.dart/dokumen1_page.dart';
import 'package:lendana5/pages/docs.dart/kk.dart';
import 'package:lendana5/pages/docs.dart/ktp_page.dart';
import 'package:lendana5/pages/foto_page.dart';

class DocPage extends StatefulWidget {
  final int userId; // Add this line

  DocPage({required this.userId}); //

  @override
  State<DocPage> createState() => _DocPageState();
}

class _DocPageState extends State<DocPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Upload Dokumen Anda',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  //  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ),
            SizedBox(height: 20),
            MyButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => KtpPage(
                              userId: widget.userId,
                            )),
                  );
                },
                child: Text('KTP/NIK', style: TextStyle(color: Colors.white))),
            SizedBox(height: 20),
            MyButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Dokumen1Page(
                              userId: widget.userId,
                            )),
                  );
                },
                child: Text('Dokumen Lain',
                    style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
