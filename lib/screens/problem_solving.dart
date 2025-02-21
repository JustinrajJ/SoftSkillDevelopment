import 'package:flutter/material.dart';

import 'AdminPage.dart';

class ProblemSolvingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Problem Solving"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Welcome to the Problem Solving Page",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(onPressed: (){
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminPage()));
            }, child:Text("Admin"))
          ],
        ),

      ),
    );
  }
}
