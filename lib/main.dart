import 'package:finalyearproject/screens/Home.dart';
import 'package:finalyearproject/screens/assessment_page.dart';
import 'package:finalyearproject/screens/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginState();
  }

  void checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Log status for debugging
    print("Is Logged In: $isLoggedIn");

    if (isLoggedIn) {
      bool isAssessmentCompleted = prefs.getBool('isAssessmentCompleted') ?? false;

      // Log the assessment completion status
      print("Assessment Completed Status: $isAssessmentCompleted");

      if (isAssessmentCompleted) {
        // If assessment is completed, navigate to Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => homepage()),
        );
      } else {
        // Always navigate to the Assessment Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AssessmentPage(
              onComplete: () async {
                await prefs.setBool('isAssessmentCompleted', true);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => homepage()),
                );
              },
            ),
          ),
        );
      }
    } else {
      // Navigate to Sign In Screen if not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Splash screen UI
      ),
    );
  }
}
