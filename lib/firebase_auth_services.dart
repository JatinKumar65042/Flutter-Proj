
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService{

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signupWithEmailAndPassword(String email , String password) async{
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email , password : password);
      return credential.user;
    } on FirebaseAuthException catch(e){
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }catch (e) {
      print(e);
    }
  }

  Future<User?> signInWithEmailAndPassword(String email , String password) async{
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email , password : password);
      return credential.user;
    }catch(e){
      print("Some error Occured");
    }
    return null ;
  }

}