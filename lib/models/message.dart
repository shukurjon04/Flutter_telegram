class MessageHistory {
  final int messageId;
  final String chatId;
  final String text;
  final String time;
  final String type;

  MessageHistory({
    required this.messageId,
    required this.chatId,
    required this.text,
    required this.time,
    required this.type,
  });

  factory MessageHistory.fromJson(Map<String, dynamic> json) {
    return MessageHistory(
      messageId: json['message_id'],
      chatId: json['chat_id'],
      text: json['text'],
      time: json['time'],
      type: json['type'],
    );
  }
}