import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:t_hunt/constants/appwriteconstants.dart';
import 'package:t_hunt/core/export.dart';
import 'package:t_hunt/core/providers.dart';
import 'package:t_hunt/models/postmodel.dart';

final postAPIProvider = Provider((ref) {
  return PostAPI(ref.watch(appwriteDatabaseProvider));
});

abstract class IPostAPI {
  FutureEither<Document> sharePost(Postmodel post);
  Future<List<Document>> getDocuments();
}

class PostAPI implements IPostAPI {
  final Databases _db;
  PostAPI(this._db);
  @override
  FutureEither<Document> sharePost(Postmodel post) async {
    try {
      final document = await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.postCollection,
          documentId: ID.unique(),
          data: post.toMap());
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
        collectionId: AppwriteConstants.postCollection);
    return documents.documents;
  }
}
