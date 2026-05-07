
class NotificationModel {
  final String title;
  final String subtitle;
  final String userImage;
  final String time;
  final String? attachment; 

  NotificationModel({
    required this.title,
    required this.subtitle,
    required this.userImage,
    required this.time,
    this.attachment,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'userImage': userImage,
      'time': time,
      'attachment': attachment,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      userImage: json['userImage'] ?? '',
      time: json['time'] ?? '',
      attachment: json['attachment'],
    );
  }
}