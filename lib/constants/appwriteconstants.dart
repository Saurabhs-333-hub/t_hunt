class AppwriteConstants {
  static const String databaseId = '650a7660052fd327fea9';
  static const String backupdatabaseId = '64d941fca4e17df31cc1';

  static const String projectId = '650a74b454fdb3c68635';
  static const String backupprojectId = '64d9484205ac1a66b919';

  static const String endPoint = 'https://167.71.224.226:443/v1';

  static const String usersCollectionbackup = '64d948680c567d228d6d';
  static const String usersCollection = '650a76732a0cb490f1c8';

  static const String postCollection = '650a76b012ee29638dfe';
  static const String repliesCollection = '648c0efba7239b5a65f7';

  static const String fileBucket = '650a76d6359b15f9b5de';
  static const String videoBucketBackup = '64d95890a070eb0fb3b2';

  static String fileUrl(String fileId) =>
      '$endPoint/storage/buckets/$fileBucket/files/$fileId/view?project=$projectId&mode=admin';
  static String videoBackupUrl(String videoBackupId) =>
      '$endPoint/storage/buckets/$videoBucketBackup/files/$videoBackupId/view?project=$projectId&mode=admin';
}
