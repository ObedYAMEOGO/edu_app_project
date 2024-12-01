import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/src/authentication/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardUtils {
  static Stream<LocalUserModel> get userDataStream => FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots()
      .map((event) => LocalUserModel.fromMap(event.data()!));
}
