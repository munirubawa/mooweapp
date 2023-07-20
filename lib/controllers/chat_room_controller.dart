
import 'package:mooweapp/export_files.dart';
class ChatRoomController extends GetxController {
  static ChatRoomController instance = Get.find();
  RxList<UserChatRoom> userChatRoom = RxList<UserChatRoom>([]);
  RxList chatRooms = [].obs;
List<String> paths = [];
  Map<String, dynamic> tokens =  {};
  RxMap<String, DocumentSnapshot> membersByContactPath =  RxMap<String, DocumentSnapshot>();
  // Rx<DocumentSnapshot> member = Rx<DocumentSnapshot>(DocumentSnapshot);
  RxMap currentMember =  {}.obs;

  @override
  void onInit() {
    userChatRoom.bindStream(getAllUserChatRooms());

  }

  Stream<List<UserChatRoom>> getAllUserChatRooms(){
    debugPrint("getAllUserChatRooms");
    return
      firebaseFirestore.collection(dbHelper.recentChats()).orderBy("time", descending: true).snapshots().map((query) =>
          query.docs.map((item) => UserChatRoom.fromSnap(item)).toList());
  }

  Stream<ChatRoom> getChatRoom(String path) => firebaseFirestore.doc(path).snapshots().map((event) => ChatRoom
      .fromSnap
    (event));

  Stream<DocumentSnapshot> getMember(String path){
   return firebaseFirestore.doc(path).snapshots().map((event){
     DocumentSnapshot member = event;
     currentMember.value = member.data() as Map<String, dynamic>;
     return event;
   });
  }
  //TODO: get the user by doc path
  void getMemberStreams(String path){
    if(!paths.contains(path)) {
      paths.add(path);

      firebaseFirestore.doc(path).get().then((event) {
        if(event.exists) {
          DocumentSnapshot member = event;
          membersByContactPath.value[path] = member;
          currentMember.value = member.data() as Map<String, dynamic>;
          debugPrint("ChatRoomController $path");
          tokens[path] = member.get(memberModel.deviceToken);
        }
      });
    }
  }

}