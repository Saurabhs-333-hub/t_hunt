import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grock/grock.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:t_hunt/apis/post_api.dart';
import 'package:t_hunt/apis/storage_api.dart';
import 'package:t_hunt/apis/story_api.dart';
import 'package:t_hunt/controllers/auth_controller.dart';
import 'package:t_hunt/core/export.dart';
import 'package:t_hunt/core/post_type.dart';
import 'package:t_hunt/models/Storymodel.dart';

final storyControllerProvider =
    StateNotifierProvider<StoryController, bool>((ref) {
  return StoryController(
      ref: ref,
      storyAPI: ref.watch(storyAPIProvider),
      storageAPI: ref.watch(storageAPIProvider));
});
final storiesProvider = FutureProvider((ref) async {
  return ref.watch(storyControllerProvider.notifier).getPosts();
});
final hashtagstoriesProvider = FutureProviderFamily((ref, String hashtag) async {
  return ref.watch(storyControllerProvider.notifier).getHashtagPosts(hashtag);
});

final weblinkstoriesProvider = FutureProviderFamily((ref, String weblink) async {
  return ref.watch(storyControllerProvider.notifier).getWeblinkPosts(weblink);
});

final emailstoriesProvider = FutureProviderFamily((ref, String email) async {
  return ref.watch(storyControllerProvider.notifier).getEmailPosts(email);
});

class StoryController extends StateNotifier<bool> {
  final Ref _ref;
  final StoryAPI _storyAPI;
  final StorageAPI _storageAPI;
  StoryController(
      {required Ref ref,
      required StoryAPI storyAPI,
      required StorageAPI storageAPI})
      : _ref = ref,
        _storyAPI = storyAPI,
        _storageAPI = storageAPI,
        super(false);
  Future<List<Storymodel>> getPosts() async {
    final storys = await _storyAPI.getDocuments();
    return storys.map((e) => Storymodel.fromMap(e.data)).toList();
  }

  Future<List<Storymodel>> getHashtagPosts(String hashtag) async {
    final storys = await _storyAPI.getHashtagDocuments(hashtag);
    return storys.map((e) => Storymodel.fromMap(e.data)).toList();
  }

  Future<List<Storymodel>> getWeblinkPosts(String weblink) async {
    final storys = await _storyAPI.getWeblinkDocuments(weblink);
    return storys.map((e) => Storymodel.fromMap(e.data)).toList();
  }

  Future<List<Storymodel>> getEmailPosts(String email) async {
    final storys = await _storyAPI.getEmailDocuments(email);
    return storys.map((e) => Storymodel.fromMap(e.data)).toList();
  }

  void deleteStory(
      {required Storymodel story, required BuildContext context}) async {
    try {
      state = true;
      await _storyAPI.deleteStory(story, context);
      String id;
      for (var link in story.imageLinks) {
        List<String> parts = link.split("/");

        // Find the index of "files" in the parts list
        int filesIndex = parts.indexOf("files");

        // Check if "files" was found and there is a part after it
        if (filesIndex != -1 && filesIndex + 1 < parts.length) {
          // The fileid should be the part after "files"
          String fileId = parts[filesIndex + 1];

          // Remove any query parameters, if any
          fileId = fileId.split("?").first;
          id = fileId;
          print("File ID: $id");
          await _storageAPI.deleteFiles(fileId);
        }
        // Split the URL by "/"
      }

      state = false;
      successSnackBar(context, "Deleted! 🥳", "Post deleted successfully");
    } catch (e) {
      state = false;
      errorSnackBar(context, "Error! 😢", e.toString());
    }
  }

  void shareStory({
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
    final weblinks = _getWebLinksFromCaption(caption);
    print('weblinks: $weblinks');

    final emails = _getEmailsFromCaption(caption);
    String link = _getLinkFromCaption(caption);
    final uid = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadFiles(images);
    addImageColor() async {
      if (imageLinks.isNotEmpty) {
        List<String> imageColors = [];
        for (String image in imageLinks) {
          // print('imageColors: $imageColors');

          if (image.isNotEmpty) {
            final PaletteGenerator paletteGenerator =
                await PaletteGenerator.fromImageProvider(NetworkImage(image),
                    // size: Size(100, 100),
                    // region: Rect.fromLTRB(0, 0, 0, 0),
                    timeout: Duration(seconds: 0));

            paletteGenerator.dominantColor == null
                ? imageColors.add(PaletteColor(Colors.black, 1).toString())
                : imageColors
                    .add(paletteGenerator.dominantColor!.color.toString());
            // print('dycolors: $dycolors');
            // setState(() {});
          }
        }
        // print(imageColors);
        return imageColors;
        // await generateBlurHashForCurrentImage();
      }
    }

    addTitleColor() async {
      if (imageLinks.isNotEmpty) {
        List<String> titleColors = [];
        for (String image in imageLinks) {
          // print('titleColors: $titleColors');

          if (image.isNotEmpty) {
            final PaletteGenerator paletteGenerator =
                await PaletteGenerator.fromImageProvider(NetworkImage(image),

                    // size: Size(100, 100),
                    timeout: Duration(seconds: 0));

            paletteGenerator.dominantColor == null
                ? titleColors.add(
                    PaletteColor(Color.fromARGB(255, 255, 255, 255), 1)
                        .toString())
                : titleColors.add(
                    paletteGenerator.dominantColor!.titleTextColor.toString());
            // print('dycolors: $dycolors');
            // setState(() {});
          }
        }
        // print(titleColors);
        return titleColors;
        // await generateBlurHashForCurrentImage();
      }
    }

    addTextColor() async {
      if (imageLinks.isNotEmpty) {
        List<String> textColors = [];
        for (String image in imageLinks) {
          // print('textColors: $textColors');

          if (image.isNotEmpty) {
            final PaletteGenerator paletteGenerator =
                await PaletteGenerator.fromImageProvider(NetworkImage(image),

                    // size: Size(100, 100),
                    timeout: Duration(seconds: 0));

            paletteGenerator.dominantColor == null
                ? textColors.add(
                    PaletteColor(const Color.fromARGB(255, 255, 255, 255), 1)
                        .toString())
                : textColors.add(
                    paletteGenerator.dominantColor!.bodyTextColor.toString());
            // print('dycolors: $dycolors');
            // setState(() {});
          }
        }
        // print(textColors);
        return textColors;
        // await generateBlurHashForCurrentImage();
      }
    }

    final imageColors = await addImageColor();
    final titleColors = await addTitleColor();
    final textColors = await addTextColor();

    print('imageColors:     $imageColors');
    print('titleColors:     $titleColors');
    print('textColors:     $textColors');
    Storymodel story = Storymodel(
      caption: caption,
      hashtags: hashtags,
      weblinks: weblinks,
      emails: emails,
      link: link,
      imageLinks: imageLinks,
      uid: uid.id,
      storyType: StoryType.image,
      storyedAt: DateTime.now(),
      likes: [],
      commentIds: [],
      storyid: '',
      isActive: true,
      reShareCount: 0,
      imageColor: imageColors ?? [],
      titleColor: titleColors ?? [],
      textColor: textColors ?? [],
      blurhash: [],
    );
    final res = await _storyAPI.shareStory(story);
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
    final weblinks = _getWebLinksFromCaption(caption);
    print('weblinks: $weblinks');
    final emails = _getEmailsFromCaption(caption);
    String link = _getLinkFromCaption(caption);
    final uid = _ref.read(currentUserDetailsProvider).value!;
    Storymodel story = Storymodel(
      caption: caption,
      hashtags: hashtags,
      weblinks: weblinks,
      emails: emails,
      link: link,
      imageLinks: [],
      uid: uid.id,
      storyType: StoryType.caption,
      storyedAt: DateTime.now(),
      likes: [],
      commentIds: [],
      storyid: '',
      isActive: true,
      reShareCount: 0,
      imageColor: [],
      titleColor: [],
      textColor: [],
      blurhash: [],
    );
    final res = await _storyAPI.shareStory(story);
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

List<String> _getWebLinksFromCaption(String caption) {
  final RegExp regex = RegExp(
    r'(https?://\S+|www\.\S+)',
    caseSensitive: false,
  );

  final Iterable<Match> matches = regex.allMatches(caption);

  List<String> webLinks = [];

  for (final match in matches) {
    String link = match.group(0)!;
    if (!link.startsWith("http://") && !link.startsWith("https://")) {
      // If link doesn't start with 'http://' or 'https://',
      // check if it starts with 'www.' and add 'http://' before it
      if (link.startsWith("www.")) {
        link = "http://" + link;
      } else {
        // If link is just domain name without 'www.', add 'http://www.' before it
        link = "http://www." + link;
      }
    }
    webLinks.add(link);
  }

  return webLinks;
}

List<String> _getEmailsFromCaption(String caption) {
  final RegExp regex = RegExp(
    r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b',
    caseSensitive: false,
  );

  final Iterable<Match> matches = regex.allMatches(caption);

  List<String> emails = [];

  for (final match in matches) {
    emails.add(match.group(0)!);
  }

  return emails;
}
