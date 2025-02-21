import 'package:finalyearproject/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authmanagement/authcontrol.dart';
import 'Home.dart';
import 'assessment_page.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _signupKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool textVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade500,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade500, Colors.blue.shade100],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _signupKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade300,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            // Username Input
                            TextFormField(
                              controller: username,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your Email";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.mail),
                                labelText: "Username",
                                labelStyle: TextStyle(color: Colors.grey),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            // Mobile Input
                            TextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              controller: mobile,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your 10 digit Mobile Number";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.mobile_friendly),
                                labelText: "Mobile Number",
                                labelStyle: TextStyle(color: Colors.grey),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            // Password Input
                            TextFormField(
                              obscureText: textVisible,
                              keyboardType: TextInputType.text,
                              controller: password,
                              maxLength: 6,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your password";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.password_rounded),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      textVisible = !textVisible;
                                    });
                                  },
                                  icon: textVisible
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                ),
                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.grey),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            // Confirm Password Input
                            TextFormField(
                              obscureText: textVisible,
                              keyboardType: TextInputType.text,
                              controller: confirmPassword,
                              maxLength: 6,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your password again";
                                }
                                if (value != password.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.password_rounded),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      textVisible = !textVisible;
                                    });
                                  },
                                  icon: textVisible
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                ),
                                labelText: "Confirm Password",
                                labelStyle: TextStyle(color: Colors.grey),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            // Sign Up Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 15),
                              ),
                              onPressed: () {
                                if (_signupKey.currentState!.validate()) {
                                  // Call the signup method
                                  Authmanage().Signup(username.text.trim(), password.text.trim()).then((value)async {
                                    // Save assessment state after successful sign-up
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    await prefs.setBool('isAssessmentCompleted', false);

                                    // Navigate to the Assessment page or homepage based on the state
                                    bool assessmentCompleted = prefs.getBool('isAssessmentCompleted') ?? false;
                                    if (!assessmentCompleted) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => AssessmentPage(onComplete: () async {
                                          // After completing the assessment, save the state
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          await prefs.setBool('isAssessmentCompleted', true);

                                          // Navigate to homepage after saving state
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => homepage(),
                                            ),
                                          );
                                        },)),
                                      );
                                    } else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => homepage()),
                                      );
                                    }
                                  }).catchError((e) {
                                    // Handle errors
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Error: ${e.toString()}")),
                                    );
                                  });
                                }
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 20),
                            // Login Text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return SignInScreen();
                                      }),
                                    ); // Navigate to login screen
                                  },
                                  child: Text("Login Now",style: TextStyle(color: Colors.blue),),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
