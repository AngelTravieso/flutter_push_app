// ignore_for_file: public_member_api_docs, sort_constructors_first
class PushMessage {
  final String messageId;
  final String title;
  final String body;
  final DateTime sentDate;
  final Map<String, dynamic>? data;
  final String? imageUrl;

  PushMessage({
    required this.messageId,
    required this.title,
    required this.body,
    required this.sentDate,
    this.data,
    this.imageUrl,
  });

  @override
  String toString() {
    return 'PushMessage(messageId: $messageId, title: $title, body: $body, sentDate: $sentDate, data: $data, imageUrl: $imageUrl)';
  }
}
