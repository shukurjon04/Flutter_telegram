import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sozlamalar',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Til'),
                  subtitle: Text('O\'zbek tili'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.dark_mode),
                  title: Text('Tungi rejim'),
                  trailing: Switch(value: false, onChanged: (val) {}),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Bildirishnomalar'),
                  trailing: Switch(value: true, onChanged: (val) {}),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ma\'lumot',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 12),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Versiya'),
                  subtitle: Text('1.0.0'),
                ),
                ListTile(
                  leading: Icon(Icons.code),
                  title: Text('Ishlab chiquvchi'),
                  subtitle: Text('Your Name'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}