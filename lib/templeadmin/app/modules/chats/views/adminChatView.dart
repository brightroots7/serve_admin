import 'package:admin/templeadmin/shared/Constants/Appcolors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'adminChatScreen.dart';

class AdminChatListView extends StatelessWidget {
  final String adminId;

  const AdminChatListView({Key? key, required this.adminId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        backgroundColor: Appcolors.appColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chats')
            .where('participants', arrayContains: adminId)
            .snapshots(),
        builder: (context, snapshot) {
          // Show Firestore errors
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // When we have data
          final chats = snapshot.data?.docs ?? [];
          print("📡 Chats fetched for admin $adminId → ${chats.length}");

          if (chats.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    "No chats yet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "User messages will appear here",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final data = chats[index].data() as Map<String, dynamic>;
              final participants = List<String>.from(data['participants']);
              final lastMessage = data['lastMessage'] ?? "";
              final lastMessageTime = data['lastMessageTime'] as Timestamp?;

              // Find the other user (devotee) id
              final otherUserId = participants.firstWhere(
                    (id) => id != adminId,
                orElse: () => "",
              );

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('users').doc(otherUserId).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return _buildChatTile(
                      context: context,
                      userName: "Loading...",
                      lastMessage: lastMessage,
                      lastMessageTime: lastMessageTime,
                      onTap: () {},
                    );
                  }

                  if (userSnapshot.hasError || !userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return _buildChatTile(
                      context: context,
                      userName: "Unknown User",
                      lastMessage: lastMessage,
                      lastMessageTime: lastMessageTime,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AdminChatScreen(
                              adminId: adminId,
                              userId: otherUserId,
                            ),
                          ),
                        );
                      },
                    );
                  }

                  final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  final userName = userData['name'] ?? "Unknown User";

                  return _buildChatTile(
                    context: context,
                    userName: userName,
                    lastMessage: lastMessage,
                    lastMessageTime: lastMessageTime,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminChatScreen(
                            adminId: adminId,
                            userId: otherUserId,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildChatTile({
    required BuildContext context,
    required String userName,
    required String lastMessage,
    required Timestamp? lastMessageTime,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepPurple[100],
            ),
            child: Center(
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : "U",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[800],
                ),
              ),
            ),
          ),
          title: Text(
            userName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(
                lastMessage.isNotEmpty ? lastMessage : "No messages yet",
                style: TextStyle(
                  fontSize: 14,
                  color: lastMessage.isNotEmpty ? Colors.grey[100] : Colors.grey[300],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (lastMessageTime != null) ...[
                SizedBox(height: 4),
                Text(
                  _formatTimestamp(lastMessageTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ],
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today at ${_formatTime(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}