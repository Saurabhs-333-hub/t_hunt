class AppwriteConstants {
  static const String databaseId = '650a7660052fd327fea9';
  static const String backupdatabaseId = '64d941fca4e17df31cc1';

  static const String projectId = '650a74b454fdb3c68635';
  static const String backupprojectId = '64d9484205ac1a66b919';

  static const String endPoint = 'https://167.71.224.226:443/v1';

  static const String usersCollectionbackup = '64d948680c567d228d6d';
  static const String usersCollection = '650a76732a0cb490f1c8';

  static const String postCollection = '650a76b012ee29638dfe';  
  static const String storyCollection = '653d04ec75e660ec2132';  

  static const String repliesCollection = '648c0efba7239b5a65f7';

  static const String fileBucket = '6533a801f247c645744b';
  static const String videoBucketBackup = '64d95890a070eb0fb3b2';

  static String fileUrl(String fileId) =>
      '$endPoint/storage/buckets/$fileBucket/files/$fileId/view?project=$projectId';
  static String videoBackupUrl(String videoBackupId) =>
      '$endPoint/storage/buckets/$videoBucketBackup/files/$videoBackupId/view?project=$projectId';
      
  
  // Split the URL by "/"
  // List<String> parts = fileUrl.split("/");
  
  // // Find the index of "files" in the parts list
  // int filesIndex = parts.indexOf("files");
  
  // // Check if "files" was found and there is a part after it
  // if (filesIndex != -1 && filesIndex + 1 < parts.length) {
  //   // The fileid should be the part after "files"
  //   String fileId = parts[filesIndex + 1];
    
  //   // Remove any query parameters, if any
  //   fileId = fileId.split("?").first;
    
  //   print("File ID: $fileId");
}
