
// ============================================
// HOME PAGE
// ============================================
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegrambot/screen/sendMessage.dart';
import 'package:telegrambot/screen/setting.dart';

import '../Provider/provider.dart';
import 'draver.dart';
import 'messageHistory.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SendMessagePage(),
    MessageHistoryPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Telegram Bot Admin'),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              final provider = Provider.of<BotProvider>(context, listen: false);
              provider.loadBotInfo();
              provider.loadMessageHistory();
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.send),
            label: 'Yuborish',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Tarix',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Sozlamalar',
          ),
        ],
      ),
    );
  }
}
