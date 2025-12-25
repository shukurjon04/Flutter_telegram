import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter/material.dart';
import 'dart:io' show Platform, SocketException;

import 'package:http/http.dart' as http;

class ApiService {
  // Avtomatik platform detection
  static const String baseUrl =
      'https://telegrambotbackend-ztud.onrender.com';

  static const String apiKey = 'your-secret-api-key-12345';

  /// POST request
  static Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> data,
      ) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'api-key': apiKey,
        },
        body: jsonEncode(data),
      );

      if (kDebugMode) {
        print('➡️ POST $uri');
        print('📩 BODY: $data');
        print('📥 STATUS: ${response.statusCode}');
        print('📥 RESPONSE: ${response.body}');
      }

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Backend xatosi: ${response.statusCode} | ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Ulanish xatosi: $e');
    }
  }

  /// Backend health check
  static Future<bool> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/health'),
        headers: {'api-key': apiKey},
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }


  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'api-key': apiKey},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }


  static Future<Map<String, dynamic>> put(
      String endpoint,
      Map<String, dynamic> data,
      ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'api-key': apiKey,
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<Map<String, dynamic>> delete(
      String endpoint,
      Map<String, dynamic> data,
      ) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'api-key': apiKey,
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
  // Ulanishni tekshirish
  Future<void> sendTelegramMessage() async {
    try {
      final result = await ApiService.post(
        '/api/telegram/send',
        {
          'chat_id': '-1002357438802',
          'text': 'nima gap',
          'parse_mode': 'HTML',
        },
      );

      print('✅ Yuborildi: $result');
    } catch (e) {
      print('❌ Xatolik: $e');
    }
  }




}

// Connection Status Widget
class ConnectionStatusWidget extends StatefulWidget {
  @override
  _ConnectionStatusWidgetState createState() => _ConnectionStatusWidgetState();
}

class _ConnectionStatusWidgetState extends State<ConnectionStatusWidget> {
  bool _isChecking = false;
  bool? _isConnected;
  String? _errorMessage;

  Future<void> _checkConnection() async {
    setState(() {
      _isChecking = true;
      _errorMessage = null;
    });

    try {
      final connected = await ApiService.checkConnection();
      setState(() {
        _isConnected = connected;
        _isChecking = false;
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
        _errorMessage = e.toString();
        _isChecking = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isConnected == true
                      ? Icons.check_circle
                      : _isConnected == false
                      ? Icons.error
                      : Icons.help,
                  color: _isConnected == true
                      ? Colors.green
                      : _isConnected == false
                      ? Colors.red
                      : Colors.grey,
                ),
                SizedBox(width: 8),
                Text(
                  'Backend Ulanish',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                if (_isChecking)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: _checkConnection,
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'URL: ${ApiService.baseUrl}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            if (_isConnected == true) ...[
              SizedBox(height: 8),
              Text(
                '✅ Server ishlab turibdi',
                style: TextStyle(color: Colors.green),
              ),
            ],
            if (_isConnected == false && _errorMessage != null) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '❌ Xatolik:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
