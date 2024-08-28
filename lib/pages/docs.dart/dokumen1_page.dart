import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lendana5/constants.dart';

import 'package:lendana5/models/user_response.dart';

class Dokumen1Page extends StatefulWidget {
  final int userId;

  const Dokumen1Page({Key? key, required this.userId}) : super(key: key);

  @override
  _Dokumen1PageState createState() => _Dokumen1PageState();
}

class _Dokumen1PageState extends State<Dokumen1Page> {
  late Future<UserResponse> _userResponseFuture;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _userResponseFuture = getUserData(widget.userId);
  }

  Future<UserResponse> getUserData(int userId) async {
    final response = await Dio().get(
      '$BASE_URLP/api/users/$userId?populate=*',
      options: Options(
        headers: {
          'Authorization': 'Bearer $API_TOKENP',
        },
      ),
    );

    if (response.statusCode == 200) {
      return UserResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadDokumen1() async {
    if (_selectedImage == null) {
      print('Error: Image file not selected');
      return;
    }

    String url = '$BASE_URLP/api/upload';
    FormData formData = FormData.fromMap({
      'files': await MultipartFile.fromFile(_selectedImage!.path),
      'refId': widget.userId,
      'ref': 'plugin::users-permissions.user',
      'field': 'dokumen1',
    });

    try {
      Response response = await Dio().post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $API_TOKENP',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('User Image added successfully');
        setState(() {
          _userResponseFuture = getUserData(widget.userId);
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Doc Image uploaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('Error adding image: ${response.data}');
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload Doc image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Exception occurred: $e');
      // Show exception message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while uploading the image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
//        title: const Text('User Page'),
      ),
      body: FutureBuilder<UserResponse>(
        future: _userResponseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            final dokumen1Url = user.dokumen1?.url != null
                ? '$BASE_URLP${user.dokumen1!.url}'
                : null;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Upload Dokumen Image',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    //  style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(height: 20),
                  if (dokumen1Url != null)
                    Image.network(
                      dokumen1Url,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return CircularProgressIndicator();
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                    )
                  else if (_selectedImage != null)
                    Image.file(
                      _selectedImage!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  else
                    Icon(Icons.card_membership_outlined, size: 150),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Select New Document Image'),
                  ),
                  ElevatedButton(
                    onPressed: _uploadDokumen1,
                    child: Text('Upload Document Image'),
                  ),
                  SizedBox(height: 20),
                  // Text('Name: ${user.nama ?? "N/A"}'),
                  // Text('NIK: ${user.nik ?? "N/A"}'),
                  // Text('Nomor HP: ${user.hp ?? "N/A"}'),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
