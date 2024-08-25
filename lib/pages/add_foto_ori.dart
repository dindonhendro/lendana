import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lendana5/models/user_response.dart';

class AddFoto extends StatefulWidget {
  final String userId; // User ID parameter

  AddFoto({required this.userId});

  @override
  _AddFotoState createState() => _AddFotoState();
}

class _AddFotoState extends State<AddFoto> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final String token = 'your_token_here'; // Replace with the actual token

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    FormData formData = FormData.fromMap({
      "files": await MultipartFile.fromFile(_imageFile!.path),
      "ref": "plugin::users-permissions.user",
      "refId": widget.userId,
      "field": "foto"
    });

    try {
      var response = await dio.post('http://coper.serveo.net/api/upload',
          data: formData, options: Options(contentType: 'multipart/form-data'));

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Image upload failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<UserResponse> _fetchUserData() async {
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      var response =
          await dio.get('http://coper.serveo.net/api/users/${widget.userId}');
      if (response.statusCode == 200) {
        return UserResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Photo'),
      ),
      body: FutureBuilder<UserResponse>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data?.foto?.url == null) {
            return Center(child: Text('No profile picture available.'));
          }

          final user = snapshot.data!;
          final profileImageUrl = user.foto?.url;

          return Column(
            children: [
              profileImageUrl != null
                  ? Image.network(profileImageUrl)
                  : Text('No profile picture available.'),
              SizedBox(height: 20),
              _imageFile != null
                  ? Image.file(_imageFile!)
                  : Text('No image selected.'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: Text('Camera'),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text('Gallery'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Upload Image'),
              ),
            ],
          );
        },
      ),
    );
  }
}
