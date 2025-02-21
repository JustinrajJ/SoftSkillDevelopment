import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ChatService.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Messages (Admin)"),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: ChatService().getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to load messages. Please try again later.",
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No users available."),
            );
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return _buildUserTile(user);
            },
          );
        },
      ),
    );
  }

  /// Builds a ListTile for a user.
  Widget _buildUserTile(Map<String, dynamic> user) {
    final username = user["username"] ?? "Unknown";
    final email = user["email"] ?? "No email provided";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            username.isNotEmpty ? username[0].toUpperCase() : "?",
            style: const TextStyle(color: Colors.blue),
          ),
        ),
        title: Text(username),
        subtitle: Text(email),
      ),
    );
  }
}
