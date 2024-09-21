class TimerModel {

  final int postId;
  final int seconds;

  const TimerModel({
    required this.postId,
    required this.seconds,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimerModel &&
          runtimeType == other.runtimeType &&
          postId == other.postId &&
          seconds == other.seconds);

  @override
  int get hashCode => postId.hashCode ^ seconds.hashCode;

  @override
  String toString() {
    return 'TimerModel{ postId: $postId, seconds: $seconds,}';
  }

  TimerModel copyWith({
    int? postId,
    int? seconds,
  }) {
    return TimerModel(
      postId: postId ?? this.postId,
      seconds: seconds ?? this.seconds,
    );
  }
}