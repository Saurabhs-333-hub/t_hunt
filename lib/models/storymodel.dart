// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:t_hunt/core/post_type.dart';

class Storymodel {
  final String caption;
  final List<String> hashtags;
  final List<String> weblinks;
  final List<String> emails;

  final String link;
  final List<String> imageLinks;
  final String uid;
  final StoryType storyType;
  final DateTime storyedAt;
  final List<String> likes;
  final List<String> commentIds;
  final String storyid;
  final bool isActive;
  final int reShareCount;
  final List<String> imageColor;
  final List<String> titleColor;
  final List<String> textColor;

  final List<String> blurhash;
  Storymodel({
    required this.caption,
    required this.hashtags,
    required this.weblinks,
    required this.emails,
    required this.link,
    required this.imageLinks,
    required this.uid,
    required this.storyType,
    required this.storyedAt,
    required this.likes,
    required this.commentIds,
    required this.storyid,
    required this.isActive,
    required this.reShareCount,
    required this.imageColor,
    required this.titleColor,
    required this.textColor,
    required this.blurhash,
  });

  Storymodel copyWith({
    String? caption,
    List<String>? hashtags,
    List<String>? weblinks,
    List<String>? emails,
    String? link,
    List<String>? imageLinks,
    String? uid,
    StoryType? storyType,
    DateTime? storyedAt,
    List<String>? likes,
    List<String>? commentIds,
    String? storyid,
    bool? isActive,
    int? reShareCount,
    List<String>? imageColor,
    List<String>? titleColor,
    List<String>? textColor,
    List<String>? blurhash,
  }) {
    return Storymodel(
      caption: caption ?? this.caption,
      hashtags: hashtags ?? this.hashtags,
      weblinks: weblinks ?? this.weblinks,
      emails: emails ?? this.emails,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      uid: uid ?? this.uid,
      storyType: storyType ?? this.storyType,
      storyedAt: storyedAt ?? this.storyedAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      storyid: storyid ?? this.storyid,
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
      'weblinks': weblinks,
      'emails': emails,
      'link': link,
      'imageLinks': imageLinks,
      'uid': uid,
      'storyType': storyType.type,
      'storyedAt': storyedAt.microsecondsSinceEpoch,
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

  factory Storymodel.fromMap(Map<String, dynamic> map) {
    return Storymodel(
      caption: map['caption'] as String,
      hashtags: List<String>.from((map['hashtags'] as List<dynamic>)),
      weblinks: List<String>.from((map['weblinks'] as List<dynamic>)),
      emails: List<String>.from((map['emails'] as List<dynamic>)),
      link: map['link'] as String,
      imageLinks: List<String>.from((map['imageLinks'] as List<dynamic>)),
      uid: map['uid'] as String,
      storyType: (map['storyType'] as String).toStoryType(),
      storyedAt: DateTime.fromMillisecondsSinceEpoch(map['storyedAt'] as int),
      likes: List<String>.from((map['likes'] as List<dynamic>)),
      commentIds: List<String>.from((map['commentIds'] as List<dynamic>)),
      storyid: map['\$id'] as String,
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
    return 'Storymodel(caption: $caption, hashtags: $hashtags, link: $link, imageLinks: $imageLinks, uid: $uid, storyType: $storyType, storyedAt: $storyedAt, likes: $likes, commentIds: $commentIds, storyid: $storyid, isActive: $isActive, reShareCount: $reShareCount, imageColor: $imageColor, titleColor: $titleColor, textColor: $textColor, blurhash: $blurhash, emails: $emails, weblinks: $weblinks)';
  }

  @override
  bool operator ==(covariant Storymodel other) {
    if (identical(this, other)) return true;

    return other.caption == caption &&
        listEquals(other.hashtags, hashtags) &&
        listEquals(other.weblinks, weblinks) &&
        listEquals(other.emails, emails) &&
        other.link == link &&
        listEquals(other.imageLinks, imageLinks) &&
        other.uid == uid &&
        other.storyType == storyType &&
        other.storyedAt == storyedAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIds, commentIds) &&
        other.storyid == storyid &&
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
        weblinks.hashCode ^
        emails.hashCode ^
        link.hashCode ^
        imageLinks.hashCode ^
        uid.hashCode ^
        storyType.hashCode ^
        storyedAt.hashCode ^
        likes.hashCode ^
        commentIds.hashCode ^
        storyid.hashCode ^
        isActive.hashCode ^
        reShareCount.hashCode ^
        imageColor.hashCode ^
        titleColor.hashCode ^
        textColor.hashCode ^
        blurhash.hashCode;
  }
}
