import 'package:flutter/material.dart';
import 'package:lendana5/components/my_button.dart';
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
        title: Text('Upload Dokumen'),
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
                child: Text('Uggah Dokumen Pelengkap',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
                child: Text('KTP/NIK')),
          ],
        ),
      ),
    );
  }
}
