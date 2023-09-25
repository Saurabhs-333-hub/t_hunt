import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grock/grock.dart';
import 'package:t_hunt/apis/post_api.dart';
import 'package:t_hunt/apis/storage_api.dart';
import 'package:t_hunt/controllers/auth_controller.dart';
import 'package:t_hunt/core/export.dart';
import 'package:t_hunt/core/post_type.dart';
import 'package:t_hunt/models/postmodel.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
      ref: ref,
      postAPI: ref.watch(postAPIProvider),
      storageAPI: ref.watch(storageAPIProvider));
});
final postsProvider = FutureProvider((ref) async {
  return ref.watch(postControllerProvider.notifier).getPosts();
});

class PostController extends StateNotifier<bool> {
  final Ref _ref;
  final PostAPI _postAPI;
  final StorageAPI _storageAPI;
  PostController(
      {required Ref ref,
      required PostAPI postAPI,
      required StorageAPI storageAPI})
      : _ref = ref,
        _postAPI = postAPI,
        _storageAPI = storageAPI,
        super(false);
  Future<List<Postmodel>> getPosts() async {
    final posts = await _postAPI.getDocuments();
    return posts.map((e) => Postmodel.fromMap(e.data)).toList();
  }

  void sharePost({
    required List<File> images,
    required String caption,
    required BuildContext context,
  }) {
    if (caption.isEmpty) {
      // showSnackBar(context, "Please write something");
      warningSnackBar(context, "Caption! 🥺", "Please write something");
      // showSnackBar(context, "Please write something");
      return;
    }
    if (images.isNotEmpty) {
      _shareImagePost(caption: caption, images: images, context: context);
    } else {
      _shareTextPost(caption: caption, context: context);
    }
  }

  void _shareImagePost({
    required List<File> images,
    required String caption,
    required BuildContext context,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromCaption(caption);
    String link = _getLinkFromCaption(caption);
    final uid = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadFiles(images);
    Postmodel post = Postmodel(
        caption: caption,
        hashtags: hashtags,
        link: link,
        imageLinks: imageLinks,
        uid: uid.id,
        postType: PostType.image,
        postedAt: DateTime.now(),
        likes: [],
        commentIds: [],
        postid: '',
        isActive: true,
        reShareCount: 0);
    final res = await _postAPI.sharePost(post);
    state = false;
    res.fold((l) {
      errorSnackBar(context, "Error! 😢", l.message);
      // showSnackBar(context, l.message);
    },
        (r) =>
            successSnackBar(context, 'Posted! 🥳', 'Post shared successfully'));
  }

  void _shareTextPost({
    required String caption,
    required BuildContext context,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromCaption(caption);
    String link = _getLinkFromCaption(caption);
    final uid = _ref.read(currentUserDetailsProvider).value!;
    Postmodel post = Postmodel(
        caption: caption,
        hashtags: hashtags,
        link: link,
        imageLinks: [],
        uid: uid.id,
        postType: PostType.caption,
        postedAt: DateTime.now(),
        likes: [],
        commentIds: [],
        postid: '',
        isActive: true,
        reShareCount: 0);
    final res = await _postAPI.sharePost(post);
    state = false;
    res.fold((l) {
      errorSnackBar(context, "Error! 😢", l.message);
      // showSnackBar(context, l.message);
    }, (r) => null);
  }

  String _getLinkFromCaption(String caption) {
    final RegExp regex = RegExp(
      r'https?://[^\s/$.?#].[^\s]*',
      caseSensitive: false,
    );

    final Iterable<Match> matches = regex.allMatches(caption);

    if (matches.isNotEmpty) {
      // Extract the first matched URL
      final Match match = matches.first;
      return match.group(0)!;
    } else {
      return ''; // No link found in the caption
    }
  }

  List<String> _getHashtagsFromCaption(String caption) {
    // List<String> hashtags = [];
    // List<String> words = caption.split(" ");
    // for (String word in words) {
    //   if (word.startsWith("#")) {
    //     hashtags.add(word);
    //   }
    // }
    // return hashtags;
    final RegExp regex = RegExp(
      r'#\w+',
      caseSensitive: false,
    );

    final Iterable<Match> matches = regex.allMatches(caption);

    List<String> hashtags = [];

    for (final match in matches) {
      hashtags.add(match.group(0)!);
    }

    return hashtags;
  }
}
