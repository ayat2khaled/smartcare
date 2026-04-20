
class NotificationModel {
  final String title;
  final String subtitle;
  final String userImage;
  final String time;
  final String? attachment; // للملفات مثل PDF

  NotificationModel({
    required this.title,
    required this.subtitle,
    required this.userImage,
    required this.time,
    this.attachment,
  });
}