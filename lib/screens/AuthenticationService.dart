import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current authenticated user
  User? get currentUser => _auth.currentUser;

  // Check if the current user is an admin (by querying Firestore)
  Future<bool> isAdmin() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // Check the user's role in Firestore
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          // Assuming the role field is stored in Firestore
          final role = userDoc.data()?['role'];
          return role == 'admin'; // Return true if the user is an admin
        }
      } catch (e) {
        print("Error checking admin role: $e");
      }
    }
    return false;
  }

  // Sign In with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }
}
