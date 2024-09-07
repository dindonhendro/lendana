import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lendana5/constants.dart';

import 'package:lendana5/models/login_response.dart';
import 'package:lendana5/models/profile_response.dart';
import 'package:lendana5/models/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiRepository {
  // Common headers used for API requests
  final Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $API_TOKENP'
  };

  // Function to handle user logout

  // Function to login the user
  Future<LoginResponse> login(String identifier, String password) async {
    final response = await http.post(
      Uri.parse('$BASE_URLP/api/auth/local'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'identifier': identifier,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(jsonDecode(response.body));

      // Save JWT token and user ID
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', loginResponse.jwt ?? '');
      await prefs.setInt('userId', loginResponse.user?.id ?? 0);
      await prefs.setBool('isLoggedIn', true);

      return loginResponse;
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('id');
    await prefs.setBool('isLoggedIn', false); // Update login state
  }

  // Function to get user data by ID
  Future<UserResponse> getUser(int id) async {
    final response = await http.get(
      Uri.parse('$BASE_URLP/api/users/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return UserResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  // Function to add a new user
  Future<UserResponse> addUser(UserResponse user) async {
    final response = await http.post(
      Uri.parse('$BASE_URLP/users'),
      headers: headers,
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      return UserResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add user');
    }
  }

  // Function to update user information
  Future<UserResponse> updateUser(UserResponse user) async {
    final response = await http.put(
      Uri.parse('$BASE_URLP/api/users/${user.id}'),
      headers: headers,
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return UserResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  // Function to delete a user by ID
  Future<void> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse('$BASE_URLP/api/users/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  // Function to get profile data by user ID
  Future<ProfileResponse> getProfile(int userId) async {
    final response = await http.get(
      Uri.parse('$BASE_URLP/api/users/$userId?populate[0]=profile_1.foto'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print(response.body);
      final jsonData = jsonDecode(response.body);
      return ProfileResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch profile: ${response.statusCode}');
    }
  }

  // Function to save the user ID to shared preferences
  Future<void> saveId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', id);
  }

  // Function to get the user ID from shared preferences
  Future<int> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id') ?? 0;
  }

  // Function to get the token from shared preferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
