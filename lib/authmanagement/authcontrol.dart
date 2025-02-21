import 'package:firebase_auth/firebase_auth.dart';

class Authmanage{
  Future Signup(String username,String password)async{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email:username,password:password,);
  }
}