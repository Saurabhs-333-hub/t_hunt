class AppwriteConstants {
  static const String databaseId = '64dae3af3fcfaec97b07';
  static const String backupdatabaseId = '64d941fca4e17df31cc1';

  static const String projectId = '64dae3614e25c5ce920d';
  static const String backupprojectId = '64d9484205ac1a66b919';

  static const String endPoint = 'https://68.183.92.66:443/v1';

  static const String usersCollectionbackup = '64d948680c567d228d6d';
  static const String usersCollection = '64dc2d5005f73d7e583c';

  static const String memoriesCollection = '6482cc639ea5db4e9457';
  static const String repliesCollection = '648c0efba7239b5a65f7';

  static const String videoBucket = '64d9587928078167936e';
  static const String videoBucketBackup = '64d95890a070eb0fb3b2';

  static String videoUrl(String videoId) =>
      '$endPoint/storage/buckets/$videoBucket/files/$videoId/view?project=$projectId&mode=admin';
  static String videoBackupUrl(String videoBackupId) =>
      '$endPoint/storage/buckets/$videoBucketBackup/files/$videoBackupId/view?project=$projectId&mode=admin';
}
