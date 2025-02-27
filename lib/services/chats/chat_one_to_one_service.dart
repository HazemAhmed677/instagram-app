import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_app/constants.dart';
import 'package:insta_app/models/user_model.dart';

class ChatOneToOneService {
  Future<void> pushMessegeToFireStore(
      {required String messege,
      required String currentUserID,
      required UserModel reciever}) async {
    String roomID =
        kChatRoomID(currentUserID: currentUserID, chatedOneID: reciever.uid);
    try {
      await FirebaseFirestore.instance
          .collection(kChats)
          .doc(roomID)
          .collection(kMesseges)
          .add({
        'content': {
          'messege': messege,
          'userID': currentUserID,
        },
        'sent at': Timestamp.now(),
      });
      FirebaseFirestore.instance.collection(kChats).doc(roomID).set({
        'content': {
          'messege': messege,
          'userID': currentUserID,
        },
        'sent at': Timestamp.now(),
        'participants': [currentUserID, reciever.uid],
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
