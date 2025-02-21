import 'package:finalyearproject/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'communication.dart';
import 'problem_solving.dart';
import 'time_management.dart';
import 'team_work.dart';
import 'emotional_intelligence.dart';
import 'assessment_page.dart';
import 'interview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homepage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homepage> {
  bool _showLoading = true;
  bool _isAssessmentCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkAssessmentStatus();
    // Simulate a loading screen delay of 2 seconds
    Timer(Duration(seconds: 2), () {
      setState(() {
        _showLoading = false;
      });
    });
  }

  Future<void> _checkAssessmentStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAssessmentCompleted = prefs.getBool('isAssessmentCompleted') ?? false;
    });
  }

  Future<void> _markAssessmentCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAssessmentCompleted', true);
    setState(() {
      _isAssessmentCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showLoading
          ? _buildLoadingScreen()
          : !_isAssessmentCompleted
          ? AssessmentPage(onComplete: _markAssessmentCompleted)
          : MainContent(), // Show main content if assessment is completed
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to Soft Skills Development",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Lottie.asset(
              'assets/images/loading.json',
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  final List<String> skills = [
    "Communication",
    "Problem Solving",
    "Time Management",
    "Team Work",
    "Emotional Intelligence",
    "Interview",
  ];

  final List<Widget> skillPages = [
    VideoRecorderApp(),
    ProblemSolvingPage(),
    TimeManagementPage(),
    TeamWorkPage(),
    EmotionalIntelligencePage(),
    InterviewPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Soft Skills")),
        backgroundColor: Colors.blue,
      ),
      drawer: _buildDrawer(context),
      body: _buildSkillGrid(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Welcome to Soft Skills',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log out'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('isAssessmentCompleted'); // Reset the assessment state
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkillGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of items per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 3,
        ),
        itemCount: skills.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => skillPages[index],
                ),
              );
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  skills[index],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
