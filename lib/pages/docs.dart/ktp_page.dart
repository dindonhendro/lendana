import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lendana5/constants.dart';

import 'package:lendana5/models/user_response.dart';

class KtpPage extends StatefulWidget {
  final int userId;

  const KtpPage({Key? key, required this.userId}) : super(key: key);

  @override
  _KtpPageState createState() => _KtpPageState();
}

class _KtpPageState extends State<KtpPage> {
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

  Future<void> _uploadKtp() async {
    if (_selectedImage == null) {
      print('Error: Image file not selected');
      return;
    }

    String url = '$BASE_URLP/api/upload';
    FormData formData = FormData.fromMap({
      'files': await MultipartFile.fromFile(_selectedImage!.path),
      'refId': widget.userId,
      'ref': 'plugin::users-permissions.user',
      'field': 'ktp',
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
      } else {
        print('Error adding image: ${response.data}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Profile'),
      //   centerTitle: true,
      // ),
      body: FutureBuilder<UserResponse>(
        future: _userResponseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            final ktpUrl =
                user.ktp?.url != null ? '$BASE_URLP${user.ktp!.url}' : null;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (ktpUrl != null)
                    Image.network(
                      ktpUrl,
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
                    Icon(Icons.person, size: 150),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Select New KTP Image'),
                  ),
                  ElevatedButton(
                    onPressed: _uploadKtp,
                    child: Text('Upload KTP Image'),
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
