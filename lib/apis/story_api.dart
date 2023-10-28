import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:t_hunt/constants/appwriteconstants.dart';
import 'package:t_hunt/core/export.dart';
import 'package:t_hunt/core/providers.dart';
import 'package:t_hunt/models/Storymodel.dart';

final storyAPIProvider = Provider((ref) {
  return StoryAPI(ref.watch(appwriteDatabaseProvider));
});

abstract class IStoryAPI {
  FutureEither<Document> shareStory(Storymodel story);
  Future<List<Document>> getDocuments();
  Future<List<Document>> getHashtagDocuments(String hashtag);
  Future<List<Document>> getWeblinkDocuments(String weblink);
  Future<List<Document>> getEmailDocuments(String email);
  Future<void> deleteStory(Storymodel story, BuildContext context);
}

class StoryAPI implements IStoryAPI {
  final Databases _db;
  StoryAPI(this._db);
  @override
  FutureEither<Document> shareStory(Storymodel story) async {
    try {
      final document = await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.storyCollection,
          documentId: ID.unique(),
          data: story.toMap());
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(
          e.message ?? "Some Unexpected Error Occured!", st.toString()));
    } catch (e, st) {
      return left(Failure(e.toString(), st.toString()));
    }
  }

  @override
  Future<List<Document>> getDocuments() async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.storyCollection);
    return documents.documents;
  }

  @override
  Future<List<Document>> getHashtagDocuments(String hashtag) async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.storyCollection,
        queries: [Query.search("hashtags", hashtag)]);
    print(documents.documents);
    return documents.documents;
  }

  @override
  Future<List<Document>> getEmailDocuments(String email) async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.storyCollection,
        queries: [Query.search("emails", email)]);
    print(documents.documents);
    return documents.documents;
  }

  @override
  Future<List<Document>> getWeblinkDocuments(String weblink) async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.storyCollection,
        queries: [Query.search("weblinks", weblink)]);
    print(documents.documents);
    return documents.documents;
  }

  @override
  Future<void> deleteStory(Storymodel story, BuildContext context) async {
    try {
      final document = await _db.deleteDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.storyCollection,
          documentId: story.storyid);
    } on AppwriteException catch (e, st) {
      errorSnackBar(context, e.message.toString(), st.toString());
    } catch (e, st) {
      errorSnackBar(context, e.toString(), st.toString());
    }
  }
}
