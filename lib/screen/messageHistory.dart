
// ============================================
// MESSAGE HISTORY PAGE
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/provider.dart';
import 'message_card.dart';

class MessageHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BotProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.messageHistory.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Hali xabarlar yo\'q',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadMessageHistory(),
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: provider.messageHistory.length,
            itemBuilder: (context, index) {
              final message = provider.messageHistory.reversed.toList()[index];
              return MessageCard(message: message);
            },
          ),
        );
      },
    );
  }
}
