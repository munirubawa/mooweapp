import 'package:mooweapp/export_files.dart';
class FirebaseStorageService {
  Future<String> uploadAvatar({
    required File file,
  }) async =>
      await upload(
        file: file,
        path: basename(file.path),
        contentType: 'image/png',
      );

  /// Generic file upload for any [path] and [contentType]
  Future<String> upload({
    required File file,
    required String path,
    required String contentType,
  }) async {
    // print('uploading to: $path');
    final storageReference = fireStorage.ref().child(path);
    final uploadTask = await storageReference.putFile(file, SettableMetadata());
    // final snapshot = await uploadTask.ref.;
    // if (snapshot.error != null) {
    //   print('upload error code: ${snapshot.error}');
    //   throw snapshot.error;
    // }
    // Url used to download file/image
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    // print('downloadUrl: $downloadUrl');
    return downloadUrl;
  }

  Future<String> uploadMessageImage({
    required File file,
  }) async =>
      await chatUploader(
        file: file,
        path: basename(file.path),
        contentType: 'image/png',
      );
  /// Generic file upload for any [path] and [contentType]
  Future<String> chatUploader({
    required File file,
    required String path,
    required String contentType,
  }) async {
    // print('uploading to: $path');
    final storageReference = fireStorage.ref().child(path);
    final uploadTask = await storageReference.putFile(file, SettableMetadata());
    // final snapshot = await uploadTask.ref.;
    // if (snapshot.error != null) {
    //   print('upload error code: ${snapshot.error}');
    //   throw snapshot.error;
    // }
    // Url used to download file/image
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    // print('downloadUrl: $downloadUrl');
    return path;
  }
}
