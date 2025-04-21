import 'package:flutter/material.dart';
import '../viewModel/register_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final viewModel = RegisterViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const SizedBox(height: 70),
              Image.asset('assets/images/logolazy.png', height: 120),
              SizedBox(height: 32),
              Text("Sign Up",
                  style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    side: BorderSide(color: Colors.blueAccent),
                  ),
                  onPressed: () => viewModel.register(
                    email: emailController.text,
                    password: passwordController.text,
                    context: context,
                  ),
                  child: const Text('Sign up',style: TextStyle(fontSize: 18, color: Colors.white),),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () => viewModel.goToLogin(context),
                child: const Text('Have an account? Login', style: TextStyle(fontSize: 15, color: Colors.black)),
              ),
            ],
          ),
      ),
    );
  }
}
