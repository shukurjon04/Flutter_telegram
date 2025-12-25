
// ============================================
// SEND MESSAGE PAGE
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/provider.dart';

class SendMessagePage extends StatefulWidget {
  @override
  _SendMessagePageState createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  final _chatIdController = TextEditingController();
  final _messageController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _videoUrlController = TextEditingController();

  bool _isLoading = false;
  String _messageType = 'text';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xabar yuborish',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 20),

                  // Chat ID
                  TextField(
                    controller: _chatIdController,
                    decoration: InputDecoration(
                      labelText: 'Kanal/Guruh ID yoki @username',
                      hintText: '-1001234567890 yoki @mychannel',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.chat),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Message Type
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'text',
                        label: Text('Matn'),
                        icon: Icon(Icons.text_fields),
                      ),
                      ButtonSegment(
                        value: 'photo',
                        label: Text('Rasm'),
                        icon: Icon(Icons.photo),
                      ),
                      ButtonSegment(
                        value: 'video',
                        label: Text('Video'),
                        icon: Icon(Icons.video_library),
                      ),
                    ],
                    selected: {_messageType},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _messageType = newSelection.first;
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Photo URL
                  if (_messageType == 'photo')
                    TextField(
                      controller: _photoUrlController,
                      decoration: InputDecoration(
                        labelText: 'Rasm URL',
                        hintText: 'https://example.com/image.jpg',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                      ),
                    ),

                  // Video URL
                  if (_messageType == 'video')
                    TextField(
                      controller: _videoUrlController,
                      decoration: InputDecoration(
                        labelText: 'Video URL',
                        hintText: 'https://example.com/video.mp4',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                      ),
                    ),

                  if (_messageType != 'text') SizedBox(height: 16),

                  // Message Text
                  TextField(
                    controller: _messageController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      labelText: _messageType == 'text' ? 'Xabar matni' : 'Izoh (caption)',
                      hintText: 'HTML formatda yozishingiz mumkin',
                      border: OutlineInputBorder(),
                      helperText: '<b>Qalin</b>, <i>Yotiq</i>, <code>Kod</code>',
                    ),
                  ),
                  SizedBox(height: 20),

                  // Send Button
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _sendMessage,
                    icon: _isLoading
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Icon(Icons.send),
                    label: Text(_isLoading ? 'Yuborilmoqda...' : 'Yuborish'),
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Quick Channels
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tez kirish',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: Text('Asosiy kanal'),
                        onSelected: (selected) {
                          _chatIdController.text = '@mainchannel';
                        },
                      ),
                      FilterChip(
                        label: Text('Test guruh'),
                        onSelected: (selected) {
                          _chatIdController.text = '@testgroup';
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_chatIdController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Barcha maydonlarni to\'ldiring!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final provider = Provider.of<BotProvider>(context, listen: false);
      final result = await provider.sendMessage(
        chatId: _chatIdController.text,
        text: _messageController.text,
        photoUrl: _messageType == 'photo' ? _photoUrlController.text : null,
        videoUrl: _messageType == 'video' ? _videoUrlController.text : null,
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Xabar muvaffaqiyatli yuborildi!'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear fields
        _messageController.clear();
        if (_messageType == 'photo') _photoUrlController.clear();
        if (_messageType == 'video') _videoUrlController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Xatolik: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _chatIdController.dispose();
    _messageController.dispose();
    _photoUrlController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }
}
