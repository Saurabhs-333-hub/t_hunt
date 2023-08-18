import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:t_hunt/constants/appwriteconstants.dart';
import 'package:t_hunt/core/export.dart';
import 'package:t_hunt/core/providers.dart';
import 'package:t_hunt/models/usermodel.dart';

final userAPIProvider = Provider((ref) {
  return UserAPI(db: ref.watch(appwriteDatabaseProvider));
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(Usermodel usermodel);
  Future<Document> getuserData(String uid);
  // Future<List<Document>> searchUserByName(String username);
}

class UserAPI implements IUserAPI {
  final Databases _db;

  UserAPI({required Databases db}) : _db = db;

  FutureEitherVoid saveUserData(Usermodel usermodel) async {
    try {
      await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: usermodel.id,
          data: usermodel.toMap());
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(
          e.message ?? "Some Unexpected Error Occured!", st.toString()));
    } catch (e, st) {
      return left(Failure(e.toString(), st.toString()));
    }
  }

  Future<Document> getuserData(String uid) async {
    final res = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: uid);
    return res;
  }
}
