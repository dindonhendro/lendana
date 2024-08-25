import 'package:flutter/material.dart';
import 'package:lendana5/repository/api_repository.dart';

class LogoutPage extends StatefulWidget {
  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  bool isLoading = false;
  String? errorMessage;

  void _logout() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await ApiRepository().logout();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $errorMessage')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logout Page')),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (errorMessage != null)
                    Text('Logout failed: $errorMessage'),
                  ElevatedButton(
                    onPressed: _logout,
                    child: Text('Logout'),
                  ),
                ],
              ),
      ),
    );
  }
}
