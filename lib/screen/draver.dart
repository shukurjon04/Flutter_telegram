
// ============================================
// DRAWER
// ============================================
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/provider.dart';
import '../models/BotInfo.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BotProvider>(context);
    final botInfo = provider.botInfo;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.telegram, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  botInfo?.firstName ?? 'Bot',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  '@${botInfo?.username ?? 'loading...'}',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.send),
            title: Text('Xabar yuborish'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Tarix'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Bot ma\'lumotlari'),
            onTap: () {
              _showBotInfoDialog(context, botInfo);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Sozlamalar'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showBotInfoDialog(BuildContext context, BotInfo? botInfo) {
    if (botInfo == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bot Ma\'lumotlari'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${botInfo.id}'),
            Text('Username: @${botInfo.username}'),
            Text('Ism: ${botInfo.firstName}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Yopish'),
          ),
        ],
      ),
    );
  }
}
