
class BotInfo {
  final int id;
  final String username;
  final String firstName;

  BotInfo({
    required this.id,
    required this.username,
    required this.firstName,
  });

  factory BotInfo.fromJson(Map<String, dynamic> json) {
    return BotInfo(
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
    );
  }
}

