// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:t_hunt/core/post_type.dart';

class Postmodel {
  final String caption;
  final List<String> hashtags;
  final String link;
  final List<String> imageLinks;
  final String uid;
  final PostType postType;
  final DateTime postedAt;
  final List<String> likes;
  final List<String> commentIds;
  final String postid;
  final bool isActive;
  final int reShareCount;
  final List<String> imageColor;
  final List<String> titleColor;
  final List<String> textColor;

  final List<String> blurhash;
  Postmodel({
    required this.caption,
    required this.hashtags,
    required this.link,
    required this.imageLinks,
    required this.uid,
    required this.postType,
    required this.postedAt,
    required this.likes,
    required this.commentIds,
    required this.postid,
    required this.isActive,
    required this.reShareCount,
    required this.imageColor,
    required this.titleColor,
    required this.textColor,
    required this.blurhash,
  });

  Postmodel copyWith({
    String? caption,
    List<String>? hashtags,
    String? link,
    List<String>? imageLinks,
    String? uid,
    PostType? postType,
    DateTime? postedAt,
    List<String>? likes,
    List<String>? commentIds,
    String? postid,
    bool? isActive,
    int? reShareCount,
    List<String>? imageColor,
    List<String>? titleColor,
    List<String>? textColor,
    List<String>? blurhash,
  }) {
    return Postmodel(
      caption: caption ?? this.caption,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      uid: uid ?? this.uid,
      postType: postType ?? this.postType,
      postedAt: postedAt ?? this.postedAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      postid: postid ?? this.postid,
      isActive: isActive ?? this.isActive,
      reShareCount: reShareCount ?? this.reShareCount,
      imageColor: imageColor ?? this.imageColor,
      titleColor: titleColor ?? this.titleColor,
      textColor: textColor ?? this.textColor,
      blurhash: blurhash ?? this.blurhash,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'caption': caption,
      'hashtags': hashtags,
      'link': link,
      'imageLinks': imageLinks,
      'uid': uid,
      'postType': postType.type,
      'postedAt': postedAt.microsecondsSinceEpoch,
      'likes': likes,
      'commentIds': commentIds,
      'isActive': isActive,
      'reShareCount': reShareCount,
      'imageColor': imageColor,
      'titleColor': titleColor,
      'textColor': textColor,
      'blurhash': blurhash,
    };
  }

  factory Postmodel.fromMap(Map<String, dynamic> map) {
    return Postmodel(
      caption: map['caption'] as String,
      hashtags: List<String>.from((map['hashtags'] as List<dynamic>)),
      link: map['link'] as String,
      imageLinks: List<String>.from((map['imageLinks'] as List<dynamic>)),
      uid: map['uid'] as String,
      postType: (map['postType'] as String).toPostType(),
      postedAt: DateTime.fromMillisecondsSinceEpoch(map['postedAt'] as int),
      likes: List<String>.from((map['likes'] as List<dynamic>)),
      commentIds: List<String>.from((map['commentIds'] as List<dynamic>)),
      postid: map['\$id'] as String,
      isActive: map['isActive'] as bool,
      reShareCount: map['reShareCount'] as int,
      imageColor: List<String>.from((map['imageColor'] as List<dynamic>)),
      titleColor: List<String>.from((map['titleColor'] as List<dynamic>)),
      textColor: List<String>.from((map['textColor'] as List<dynamic>)),
      blurhash: List<String>.from((map['blurhash'] as List<dynamic>)),
    );
  }

  @override
  String toString() {
    return 'Postmodel(caption: $caption, hashtags: $hashtags, link: $link, imageLinks: $imageLinks, uid: $uid, postType: $postType, postedAt: $postedAt, likes: $likes, commentIds: $commentIds, postid: $postid, isActive: $isActive, reShareCount: $reShareCount, imageColor: $imageColor, titleColor: $titleColor, textColor: $textColor, blurhash: $blurhash)';
  }

  @override
  bool operator ==(covariant Postmodel other) {
    if (identical(this, other)) return true;

    return other.caption == caption &&
        listEquals(other.hashtags, hashtags) &&
        other.link == link &&
        listEquals(other.imageLinks, imageLinks) &&
        other.uid == uid &&
        other.postType == postType &&
        other.postedAt == postedAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIds, commentIds) &&
        other.postid == postid &&
        other.isActive == isActive &&
        other.reShareCount == reShareCount &&
        listEquals(other.imageColor, imageColor) &&
        listEquals(other.titleColor, titleColor) &&
        listEquals(other.textColor, textColor) &&
        listEquals(other.blurhash, blurhash);
  }

  @override
  int get hashCode {
    return caption.hashCode ^
        hashtags.hashCode ^
        link.hashCode ^
        imageLinks.hashCode ^
        uid.hashCode ^
        postType.hashCode ^
        postedAt.hashCode ^
        likes.hashCode ^
        commentIds.hashCode ^
        postid.hashCode ^
        isActive.hashCode ^
        reShareCount.hashCode ^
        imageColor.hashCode ^
        titleColor.hashCode ^
        textColor.hashCode ^
        blurhash.hashCode;
  }
}
