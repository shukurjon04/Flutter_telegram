import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/provider.dart';
import '../models/message.dart';

class MessageCard extends StatelessWidget {
  final MessageHistory message;

  const MessageCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(_getTypeIcon()),
        ),
        title: Text(
          message.text.length > 50
              ? '${message.text.substring(0, 50)}...'
              : message.text,
        ),
        subtitle: Text(
          '${message.chatId} • ${_formatTime(message.time)}',
          style: TextStyle(fontSize: 12),
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Tahrirlash'),
                contentPadding: EdgeInsets.zero,
              ),
              onTap: () => _editMessage(context),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('O\'chirish', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
              onTap: () => _deleteMessage(context),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (message.type) {
      case 'photo':
        return Icons.photo;
      case 'video':
        return Icons.video_library;
      default:
        return Icons.message;
    }
  }

  String _formatTime(String isoTime) {
    try {
      final dateTime = DateTime.parse(isoTime);
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute}';
    } catch (e) {
      return isoTime;
    }
  }

  void _editMessage(BuildContext context) {
    Future.delayed(Duration.zero, () {
      _showEditDialog(context);
    });
  }

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: message.text);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xabarni tahrirlash'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Yangi matn',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Bekor qilish'),
          ),
          FilledButton(
            onPressed: () async {
              final provider = Provider.of<BotProvider>(context, listen: false);
              try {
                await provider.editMessage(
                  chatId: message.chatId,
                  messageId: message.messageId,
                  text: controller.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ Xabar tahrirlandi')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('❌ Xatolik: $e')),
                );
              }
            },
            child: Text('Saqlash'),
          ),
        ],
      ),
    );
  }

  void _deleteMessage(BuildContext context) {
    Future.delayed(Duration.zero, () {
      _showDeleteDialog(context);
    });
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('O\'chirish'),
        content: Text('Ushbu xabarni o\'chirishni xohlaysizmi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Yo\'q'),
          ),
          FilledButton(
            onPressed: () async {
              final provider = Provider.of<BotProvider>(context, listen: false);
              try {
                await provider.deleteMessage(
                  chatId: message.chatId,
                  messageId: message.messageId,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ Xabar o\'chirildi')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('❌ Xatolik: $e')),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Ha, o\'chirish'),
          ),
        ],
      ),
    );
  }
}
