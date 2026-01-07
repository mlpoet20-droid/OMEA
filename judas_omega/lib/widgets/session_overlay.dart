import 'package:flutter/material.dart';
import '../utils/session_manager.dart';

class SessionOverlay extends StatelessWidget {
  final SessionManager sessionManager = SessionManager();

  @override
  Widget build(BuildContext context) {
    String currentSession = sessionManager.getCurrentSession();
    double multiplier = sessionManager.sessionAggressionMultiplier();

    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text("Session: $currentSession | Aggression x$multiplier",
          style: TextStyle(color: Colors.white)),
    );
  }
}
