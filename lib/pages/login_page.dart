import 'package:flutter/material.dart';
import 'package:lendana5/repository/api_repository.dart';
import 'package:lendana5/pages/landing_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final userResponse = await ApiRepository().login(
        usernameController.text,
        passwordController.text,
      );

      if (userResponse.user != null && userResponse.user!.id != null) {
        await ApiRepository().saveId(userResponse.user!.id!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
        );
      } else {
        setState(() {
          errorMessage = 'Login failed';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[175], // Transparent light grey background
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo at the top
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/PM1.jpeg', // Assuming pm2.jpeg is the correct logo
                            height: 150, // Set your desired height
                          ),
                        ),
                        SizedBox(height: 20),

                        Text(
                          "Please sign in to continue",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 30),
                        // Username TextField
                        TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        // Password TextField
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        if (errorMessage != null)
                          Text(
                            errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 100, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            "Don't have an account? Register",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
