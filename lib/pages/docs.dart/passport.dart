import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lendana5/models/user_response.dart';
import 'package:lendana5/repository/api_repository.dart';
import 'package:lendana5/models/profile_response.dart';

class passport extends StatefulWidget {
  final int? userId;

  const passport({Key? key, required this.userId}) : super(key: key);

  @override
  _passportState createState() => _passportState();
}

class _passportState extends State<passport> {
  late Future<ProfileResponse?> _profileFuture;
  late Future<UserResponse> _userResponseFuture;
  File? _imageFile;

  Future<UserResponse> getFoto(int userId) async {
    final response = await http.get(
      Uri.parse(
        'http://10.0.2.2:1337/api/users/$userId?populate=*',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return UserResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch profile: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile(widget.userId!);
    _userResponseFuture = getFoto(widget.userId!);
  }

  Future<ProfileResponse?> _loadProfile(int userId) async {
    try {
      ApiRepository apiRepository = ApiRepository();
      return await apiRepository.getProfile(userId);
    } catch (e) {
      return null;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _addProfile(BuildContext context) async {
    if (_imageFile == null) {
      print('Error: Image file not selected');
      return;
    }

    String url = 'http://10.0.2.2:1337/api/upload';
    FormData formData = FormData.fromMap({
      'files': await MultipartFile.fromFile(_imageFile!.path),
      'refId': widget.userId,
      'ref': 'plugin::users-permissions.user',
      'field': 'passport',
    });

    try {
      Response response = await Dio().post(url,
          data: formData,
          options: Options(
            headers: {
              'Authorization':
                  'Bearer 0d235dadc674344da8a2665ae5a4a0db43cebc632d94ca44cdd16ac1d38181951cd0cae558310eba9e368b8ff3c055405d3737495b27d93c24c11d797b17cb98e3e446f7a0f92bf1997b23bf74f3fd4edafc6c4eed784a86d7af86f27b62a18712e14f33c31c2accdff04b7d86ebe68990a834622c9b292464c4d7df059a7627' // Replace with your actual token
            },
          ));

      if (response.statusCode == 200) {
        print('User Image added successfully');
        setState(() {
          _userResponseFuture = getFoto(widget.userId!);
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
      body: FutureBuilder<ProfileResponse?>(
        future: _profileFuture,
        builder: (context, profileSnapshot) {
          return FutureBuilder<UserResponse>(
            future: _userResponseFuture,
            builder: (context, userSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting ||
                  userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (profileSnapshot.hasError || userSnapshot.hasError) {
                return Center(child: Text('Error loading profile'));
              } else if (profileSnapshot.hasData && userSnapshot.hasData) {
                final profile = profileSnapshot.data!;
                final user = userSnapshot.data!;
                return Center(
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          Text('Passport Photo:',
                              style: TextStyle(fontSize: 12)),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipOval(
                              child: Image.network(
                                'http://10.0.2.2:1337${user.passport?.url ?? '/uploads/wm3_51e2930f2d.jpg'}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),

                      _imageFile != null
                          ? Image.file(
                              _imageFile!,
                              height: 200,
                            )
                          : Text('No image selected.'),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: Text('Pick Image'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _addProfile(context);
                        },
                        child: Text('Add Passport Image'),
                      ),
                      // Add more fields as needed
                    ],
                  ),
                );
              } else {
                return Center(child: Text('No profile data'));
              }
            },
          );
        },
      ),
    );
  }
}
