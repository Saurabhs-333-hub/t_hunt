import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:t_hunt/constants/appwriteconstants.dart';
import 'package:t_hunt/core/providers.dart';

final storageAPIProvider = Provider((ref) {
  return StorageAPI(storage: ref.watch(appwriteStorageProvider));
});

class StorageAPI {
  final Storage _storage;
  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadFiles(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uplaodedImage = await _storage.createFile(
          bucketId: AppwriteConstants.fileBucket,
          fileId: ID.unique(),
          file: InputFile.fromPath(path: file.path));
      imageLinks.add(AppwriteConstants.fileUrl(uplaodedImage.$id));
    }
    return imageLinks;
  }
}
