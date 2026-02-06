import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_message.dart';
import '../providers/auth_provider.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            const Padding(
              padding: EdgeInsets.only(right: 8, top: 4),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFF0A2A43),
                child: Text("🐠", style: TextStyle(fontSize: 16)),
              ),
            ),

          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:
                    isUser ? const Color(0xFF0A2A43) : const Color(0xFF111827),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                  bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isUser)
                    Padding(
                      padding: const EdgeInsets.only(right: 6, top: 2),
                      child: Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          if (auth.isLoggedIn) {
                            return const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person,
                                  size: 14, color: Colors.white),
                            );
                          }
                          return const Icon(
                            Icons.person,
                            size: 14,
                            color: Colors.white70,
                          );
                        },
                      ),
                    ),
                  Flexible(
                    child: Text(
                      message.text,
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isUser) const SizedBox(width: 22), // balance spacing
        ],
      ),
    );
  }
}
