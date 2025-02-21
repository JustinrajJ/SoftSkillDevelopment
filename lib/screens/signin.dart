import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AdminPage.dart';
import 'home.dart';
import 'forgot.dart';
import 'signup.dart';
import 'assessment_page.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool textVisible = true;
  final _signInFormKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  // Display SnackBar for feedback
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Save login state in SharedPreferences
  Future<void> saveLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true); // Mark as logged in
  }

  // Check if assessment is completed
  Future<bool> isAssessmentCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isCompleted = prefs.getBool('isAssessmentCompleted') ?? false;
    print('Assessment completed: $isCompleted'); // Debugging line
    return isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  // Form Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _signInFormKey,
                      child: Column(
                        children: [
                          // Title
                          Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          SizedBox(height: 20),
                          // Username Field
                          TextFormField(
                            controller: username,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter your Email";
                              }
                              if (!RegExp(
                                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                                  .hasMatch(value)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email, color: Colors.blue),
                              filled: true,
                              fillColor: Colors.blue.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          // Password Field
                          TextFormField(
                            controller: password,
                            obscureText: textVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter your Password";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: Icon(Icons.lock, color: Colors.blue),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    textVisible = !textVisible;
                                  });
                                },
                                icon: textVisible
                                    ? Icon(Icons.visibility, color: Colors.blue)
                                    : Icon(Icons.visibility_off,
                                    color: Colors.blue),
                              ),
                              filled: true,
                              fillColor: Colors.blue.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Sign In Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            onPressed: () async {
                              if (_signInFormKey.currentState!.validate()) {
                                try {
                                  // Firebase Sign In
                                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                                    email: username.text.trim(),
                                    password: password.text.trim(),
                                  );

                                  // Save login state
                                  await saveLoginState();

                                  // Check if assessment is completed
                                  bool assessmentCompleted = await isAssessmentCompleted();
                                  print('Assessment Completed Status: $assessmentCompleted'); // Debugging line

                                  if (!assessmentCompleted) {
                                    // Navigate to AssessmentPage if assessment is not completed
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AssessmentPage(
                                          onComplete: () async {
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
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Navigate directly to HomePage if assessment is completed
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => homepage(),
                                      ),
                                    );
                                  }
                                } catch (error) {
                                  showSnackBar("Error: ${error.toString()}");
                                }
                              }
                            },
                            child: Text("Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ),
                          SizedBox(height: 20),
                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return forgot();
                                  }),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.blue.shade700),
                              ),
                            ),
                          ),
                          Divider(height: 30, color: Colors.grey.shade300),
                          // Signup Prompt
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("New User?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return Signup();
                                    }),
                                  );
                                },
                                child: Text(
                                  "Sign up Now",
                                  style: TextStyle(color: Colors.blue.shade700),
                                ),
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
        ),
      ),
    );
  }
}
