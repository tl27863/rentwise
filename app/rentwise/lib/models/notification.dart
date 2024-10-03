class Notification{
  final String uid;
  final String title;
  final String content;

  const Notification({
    required this.uid,
    required this.title,
    required this.content
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'title': title,
    'content': content
  };
}