class Post {

  final int userId;
  final int id;
  final String title;
  final String body;
  final bool isRead;

  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    this.isRead = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Post &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          id == other.id &&
          title == other.title &&
          body == other.body && isRead == other.isRead);

  @override
  int get hashCode =>
      userId.hashCode ^ id.hashCode ^ title.hashCode ^ body.hashCode ^ isRead.hashCode;

  @override
  String toString() {
    return 'Post{ userId: $userId, id: $id, title: $title, isRead: $isRead}';
  }

  Post copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
    bool? isRead,
  }) {
    return Post(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
      // 'is_read': isRead ? 1 : 0,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      userId: map['userId'] as int,
      id: map['id'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
    );
  }

  factory Post.fromLocalMap(Map<String, dynamic> map) {
    return Post(
      userId: map['userId'] as int,
      id: map['id'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
      isRead: (map['is_read'] as int?) == 1 ? true : false,
    );
  }
}
