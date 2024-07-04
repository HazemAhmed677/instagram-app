import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_app/constants.dart';
import 'package:insta_app/models/user_model.dart';
import 'package:insta_app/services/fetch_user_data_service.dart';

class UploadUserData {
  Future<void> addUserDataInFireStore(
      {required String username,
      required String email,
      required String password,
      String? imageURL,
      List? followers,
      List? following}) async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    UserModel userModel = UserModel(
      username: username,
      email: email,
      password: password,
      profileImageURL: imageURL,
      followers: [],
      following: [],
      uid: uid,
    );
    FetchUserDataService();
    Map<String, dynamic> userMap = userModel.convertToMap(userModel);
    await FirebaseFirestore.instance.collection(kUsers).doc(uid).set(userMap);
  }
}
