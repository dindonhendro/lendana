import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lendana5/constants.dart';
import 'package:lendana5/models/user_response.dart';

class ProfilePage extends StatefulWidget {
  final int userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserResponse> _userResponseFuture;
  File? _selectedImage;
  bool isLoading = false;

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

  Future<void> _uploadFoto() async {
    if (_selectedImage == null) {
      print('Error: Image file not selected');
      return;
    }

    String url = '$BASE_URLP/api/upload';
    FormData formData = FormData.fromMap({
      'files': await MultipartFile.fromFile(_selectedImage!.path),
      'refId': widget.userId,
      'ref': 'plugin::users-permissions.user',
      'field': 'foto',
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

  Future<void> _deleteUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Dio().delete(
        '$BASE_URLP/api/users/${widget.userId}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $API_TOKENP',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('User deleted successfully');
        Navigator.pop(context);
      } else {
        print('Error deleting user: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting user: ${response.data}')),
        );
      }
    } catch (e) {
      print('Exception occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _refreshProfile() {
    setState(() {
      _userResponseFuture = getUserData(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<UserResponse>(
              future: _userResponseFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final user = snapshot.data!;
                  final fotoUrl = user.foto?.url != null
                      ? '$BASE_URLP${user.foto!.url}'
                      : null;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 75,
                                backgroundImage: fotoUrl != null
                                    ? NetworkImage(fotoUrl)
                                    : _selectedImage != null
                                        ? FileImage(_selectedImage!)
                                        : AssetImage(
                                                'assets/default_avatar.png')
                                            as ImageProvider,
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            '${user.nama ?? "N/A"}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          itemProfile(
                              'NIK', '${user.nik}', Icons.perm_identity),
                          const SizedBox(height: 10),
                          itemProfile('Email', '${user.email}', Icons.mail),
                          const SizedBox(height: 10),
                          itemProfile(
                              'No HP', '${user.hp}', Icons.phone_android),
                          const SizedBox(height: 10),
                          itemProfile('Alamat', '${user.domisili}', Icons.home),
                          const SizedBox(height: 10),
                          itemProfile('Jenis Kelamin', '${user.jenis}',
                              Icons.person_outline),
                          const SizedBox(height: 10),
                          itemProfile(
                              'Status', '${user.status}', Icons.star_outline),
                          const SizedBox(height: 10),
                          itemProfile('Tanggal Lahir', '${user.tanggalLahir}',
                              Icons.brightness_high_outlined),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshProfile,
        child: Icon(Icons.refresh),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

itemProfile(String title, String subtitle, IconData iconData) {
  return Container(
    decoration: BoxDecoration(color: Colors.white, boxShadow: [
      BoxShadow(
          offset: Offset(0, 5),
          color: Colors.blueAccent.withOpacity(.2),
          spreadRadius: 2,
          blurRadius: 10)
    ]),
    child: ListTile(
      title: Stack(
        children: [
          // Blurred text layer
          Text(
            title,
            style: TextStyle(
              fontSize: 8, // Smaller size
              color: Colors.blueAccent.withOpacity(0.1), // Light blue color
              fontWeight: FontWeight.w100,
            ),
          ),
          // Clear text layer
          Text(
            title,
            style: TextStyle(
              fontSize: 14, // Smaller size
              color: Colors.blueAccent, // Blue color
            ),
          ),
        ],
      ),
      subtitle: Text(subtitle),
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent.withOpacity(0.1),
        child: Icon(iconData, color: Colors.blueAccent),
      ),
      //trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
      tileColor: Colors.white,
    ),
  );
}
