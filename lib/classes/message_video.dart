

import 'package:cloud_firestore/cloud_firestore.dart';

class VideoMessage {
  List<dynamic>? imageUrls;
  String? text;
  Timestamp? time;

//<editor-fold desc="Data Methods">

  VideoMessage({
    this.imageUrls,
    this.text,
    this.time,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VideoMessage &&
          runtimeType == other.runtimeType &&
          imageUrls == other.imageUrls &&
          text == other.text &&
          time == other.time);

  @override
  int get hashCode => imageUrls.hashCode ^ text.hashCode ^ time.hashCode;

  @override
  String toString() {
    return 'VideoMessage{' ' imageUrls: $imageUrls,' ' text: $text,' ' time: $time,' '}';
  }

  VideoMessage copyWith({
    List<dynamic>? imageUrls,
    String? text,
    Timestamp? time,
  }) {
    return VideoMessage(
      imageUrls: imageUrls ?? this.imageUrls,
      text: text ?? this.text,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrls': imageUrls,
      'text': text,
      'time': time,
    };
  }

  factory VideoMessage.fromMap(Map<String, dynamic> map) {
    return VideoMessage(
      imageUrls: map['imageUrls'] as List<dynamic>,
      text: map['text'] as String,
      time: map['time'] as Timestamp,
    );
  }

//</editor-fold>
}