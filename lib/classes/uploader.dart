import 'package:mooweapp/export_files.dart';
class Uploader extends ChangeNotifier {

  Future<String> getImageUrl(List<dynamic> listFile, String contractId) async {
    String? downloadUrl;
    List<String> urls = [];

    List files = listFile;
    final storage = FirebaseStorageService();
    for (var pfile in files)  {
      downloadUrl = await storage.uploadAvatar(file: File(pfile.path));
      urls.add(downloadUrl);
      // print("uploading now $urls");
      print("uploading now $urls");
      ProfOfWork profOfWork = ProfOfWork();
      profOfWork.firstName = chatServices.localMember!.get(memberModel.firstName);
      profOfWork.uploaderUid = auth.currentUser!.uid;
      profOfWork.images = urls;
      profOfWork.timeStamp = Timestamp.now();

      FirebaseFirestore.instance
          .collection(
        "contracts",
      )
          .doc(contractId)
          .collection("profOfWork")
          .add(profOfWork.toMap())
          .then((data) {
        notifyListeners();
      });
    }
    return downloadUrl!;
  }

  bool isSubmited = false;

  Future<void> changeSubmit(bool bool) {
    isSubmited = bool;
    notifyListeners();
    return Future.value(null);
  }

  waite() {
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: CircularProgressIndicator(),
    );
  }
}