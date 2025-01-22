import 'package:beauty_spa/views/home/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showError = false;
  String _errorMessage = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        setState(() {
          _showError = false;
          _errorMessage = '';
        });

        // Navigate to Home Page on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _showError = true;
          if (e.code == 'user-not-found') {
            _errorMessage = 'No user found for that email.';
          } else if (e.code == 'wrong-password') {
            _errorMessage = 'Wrong password provided for that user.';
          } else {
            _errorMessage = e.message ?? 'An error occurred. Please try again.';
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome Back! 👋",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDE778C),
                  ),
                ),
                const Text(
                  "Login to Continue...",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500, color: Color.fromRGBO(9, 0, 0, 0.529)),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Enter your email",
                          hintStyle: const TextStyle(color: Color.fromARGB(255, 200, 199, 199)),
                          prefixIcon: const Icon(Icons.person,
                              color: Color(0xFFDE778C)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.5)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.5)),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Please enter username" : null,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Password",
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500, color: Color.fromRGBO(9, 0, 0, 0.529)),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Enter password",
                          hintStyle: const TextStyle(color: Color.fromARGB(255, 200, 199, 199),),
                          prefixIcon:
                              const Icon(Icons.lock, color: Color(0xFFDE778C)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.5)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.5)),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Please enter password" : null,
                      ),
                      const SizedBox(height: 24),
                      if (_showError)
                        Center(
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 225, 109, 132),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: _login,
                          child: const Text(
                            "Log In",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpPage()),
                              );
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                color: Color(0xFFDE778C),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            onPressed: () {
                              // Handle Google Login
                            },
                            icon: const Icon(
                              Icons.g_mobiledata,
                              color: Color(0xFFDB4437),
                            ),
                            label: const Text("Continue with Google"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
