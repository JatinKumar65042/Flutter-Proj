import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthController extends GetxController {
  var userId;

  Future<void> signup(String username, String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      userId = credential.user!.uid;

      // ✅ Save user data to Firestore
      await FirebaseFirestore.instance.collection("users").doc(userId).set({
        "username": username,
        "email": email.trim(),
        "uid": userId,
        "createdAt": FieldValue.serverTimestamp(),  // Firestore Timestamp
      });

      // ✅ Show success message
      Fluttertoast.showToast(
        msg: "Signup Successful 🎉",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      print(credential);
      Get.offAllNamed('/home');

    } on FirebaseAuthException catch (e) {
      String errorMessage = "Something went wrong";

      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      }

      // ❌ Show error message
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      userId = credential.user!.uid;

      // ✅ Show success message
      Fluttertoast.showToast(
        msg: "Login Successful 🎉",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      print(credential);
      Get.offAllNamed('/home');

    } on FirebaseAuthException catch (e) {
      String errorMessage = "Something went wrong";

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }

      // ❌ Show error message
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
