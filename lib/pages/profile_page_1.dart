import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lendana5/constants.dart';
import 'package:lendana5/models/user_response.dart';
import 'package:lendana5/repository/api_repository.dart';
import 'package:lendana5/models/profile_response.dart';

class ProfilePage1 extends StatefulWidget {
  final int userId;

  const ProfilePage1({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePage1State createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<ProfilePage1> {
  late Future<ProfileResponse?> _profileFuture;
  late Future<UserResponse> _userResponseFuture;
  File? _imageFile;

  Future<UserResponse> getFoto(int userId) async {
    final response = await http.get(
      Uri.parse(
        '$BASE_URLP/api/users/$userId?populate=*',
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

    String url = '$BASE_URLP/api/upload';
    FormData formData = FormData.fromMap({
      'files': await MultipartFile.fromFile(_imageFile!.path),
      'refId': widget.userId,
      'ref': 'plugin::users-permissions.user',
      'field': 'foto',
    });

    try {
      Response response = await Dio().post(url,
          data: formData,
          options: Options(
            headers: {
              'Authorization':
                  'Bearer $API_TOKENP' // Replace with your actual token
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

  Future<void> _deleteUser(int id) async {
    try {
      await ApiRepository().deleteUser(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted successfully')),
      );
      Navigator.popUntil(
          context, (route) => route.isFirst); // Go back to the previous screen
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //  Navigator.pop(context);
          },
        ),
      ),
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
                          Text('Profile Photo:',
                              style: TextStyle(fontSize: 12)),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipOval(
                              child: Image.network(
                                '$BASE_URLP${user.foto?.url ?? '/uploads/wm3_51e2930f2d.jpg'}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      ListTile(
                        title: Text(user.nama ?? 'N/A'),
                        subtitle: Text(user.email ?? 'N/A'),
                      ),
                      ListTile(
                        title: Text(user.hp ?? 'N/A'),
                        subtitle: Text(user.nik ?? 'N/A'),
                      ),
                      ListTile(
                        title: Text(user.nik ?? 'N/A'),
                        subtitle: Text(user.hp ?? 'N/A'),
                      ),
                      _imageFile != null
                          ? Image.file(
                              _imageFile!,
                              height: 200,
                            )
                          : Text(''),
                      // ElevatedButton(
                      //   onPressed: _pickImage,
                      //   child: Text('Pick Image'),
                      // ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     _addProfile(context);
                      //   },
                      //   child: Text('Add Foto Image'),
                      // ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _deleteUser(widget.userId),
                        child: Text('Delete User'),
                        //                  style: ElevatedButton.styleFrom(primary: Colors.red),
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
