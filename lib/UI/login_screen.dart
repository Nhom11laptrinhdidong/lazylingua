import 'package:flutter/material.dart';
import '../viewModel/login_viewmodel.dart';
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final viewModel = LoginViewModel();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logolazy.png', height: 120),
              SizedBox(height: 32),
              Text("Welcome!",
                  style: TextStyle(
                      fontSize: 38, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text(
                "Please sign in with your account to continue.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 33),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    side: BorderSide(color: Colors.blueAccent),
                  ),
                  onPressed: () => viewModel.loginWithEmail(
                    email: emailController.text,
                    password: passwordController.text,
                    context: context,
                  ),
                  child: Text('Login',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    side: BorderSide(color: Colors.white),
                  ),
                  onPressed: () => viewModel.signInWithGoogle(context),
                  label: Text('Sign in with Google',
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                  icon: Icon(Icons.g_mobiledata, size: 40),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent,
                    side: BorderSide(color: Colors.white),
                  ),
                  onPressed: () => viewModel.signInAsGuest(context),
                  icon: Icon(Icons.person_outline, size: 35),
                  label: Text('Login as guest',
                      style:
                      TextStyle(fontSize: 18, color: Colors.black)),
                ),
              ),
              SizedBox(height: 70),
              TextButton(
                onPressed: () => viewModel.goToRegister(context),
                child: Text('Don\'t have an account? Sign up', style: TextStyle(fontSize: 15, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
