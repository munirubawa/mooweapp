import 'package:cloud_firestore/cloud_firestore.dart';

class PictureMessage {
  List<dynamic>? imageUrls;
  String? text;
  Timestamp? time;

//<editor-fold desc="Data Methods">

  PictureMessage({
   required this.imageUrls,
    required  this.text,
    required  this.time,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PictureMessage &&
          runtimeType == other.runtimeType &&
          imageUrls == other.imageUrls &&
          text == other.text &&
          time == other.time);

  @override
  int get hashCode => imageUrls.hashCode ^ text.hashCode ^ time.hashCode;

  @override
  String toString() {
    return 'PictureMessage{' ' imageUrls: $imageUrls,' ' text: $text,' ' time: $time,' '}';
  }

  PictureMessage copyWith({
    List<dynamic>? imageUrls,
    String? text,
    Timestamp? time,
  }) {
    return PictureMessage(
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

  factory PictureMessage.fromMap(Map<String, dynamic> map) {
    return PictureMessage(
      imageUrls: map['imageUrls'] as List<dynamic>,
      text: map['text'] as String,
      time: map['time'] as Timestamp,
    );
  }

//</editor-fold>
}