import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class forgot extends StatefulWidget {
  const forgot({super.key});

  @override
  State<forgot> createState() => _ForgotState();
}

class _ForgotState extends State<forgot> {
  final resetKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  // Function to show SnackBar for feedback
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Form(
            key: resetKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 300,
                  width: 400,
                  child: Image.asset("assets/images/forgot.png"),
                ),
                Text(
                  "Forgot your password?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "No worries, please enter your email to receive a password reset link.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return "Please enter your email";
                      }
                      // Email format validation (simple regex check)
                      if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(email)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    controller: emailController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.email),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (resetKey.currentState!.validate()) {
                        FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text).then((_) {
                          showSnackBar("Password reset link sent! Check your email.");
                          // Optionally navigate to another screen after success
                        }).catchError((e) {
                          showSnackBar("Error: ${e.message}");
                        });
                      }
                    },
                    child: Text(
                      "Get Reset Link",
                      style: TextStyle(color: Colors.white),
                    ),
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
