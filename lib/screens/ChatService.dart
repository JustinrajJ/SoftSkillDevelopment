import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches a stream of user data from Firestore.
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      // Safely map documents and cast data to Map<String, dynamic>
      return snapshot.docs.map((document) {
        final data = document.data();

        // Safely cast the data to Map<String, dynamic>
        if (data is Map<String, dynamic>) {
          return data; // Correctly typed
        } else {
          return <String, dynamic>{}; // Return an empty map if the type doesn't match
        }
      }).toList();
    });
  }
}
