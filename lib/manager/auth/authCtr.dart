

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_care/_doctor/home/doctorHome_ctr.dart';
import 'package:smart_care/manager/auth/login.dart';
import 'package:smart_care/manager/auth/register.dart';
import 'package:smart_care/manager/auth/registerSelectType.dart';
import 'package:smart_care/manager/firebaseVoids.dart';
import 'package:smart_care/manager/myVoids.dart';

import '../../main.dart';
import '../../models/user.dart';


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: '929755544528-6rml099rfl727bsp8rnak4qju4vt3fgd.apps.googleusercontent.com',//web
);


class AuthController extends GetxController {
  static AuthController instance = Get.find();
  ScUser cUser = ScUser();
  late Rx<User?> firebaseUser;
  late Rx<GoogleSignInAccount?> googleSignInAccount;

  late  Worker worker;
  late  Worker workerGgl;


  late  StreamSubscription<QuerySnapshot> streamSub;



  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 0), () {
      //streamingDoc(usersColl,'Y1nMifjP7ga7lTNW4pZd');

    });
  }
  @override
  void onClose() {
    super.onClose();
    stopStreamingDoc();
  }

  /// //////////////////////////////////////////////////////////////////:




  deleteUserFromAuth(email,pwd) async {
    //auth user to delete
    await fbAuth.signInWithEmailAndPassword(
      email: email,
      password: pwd,
    ).then((value) async {
      print('## account: <${authCurrUser!.email}> deleted');
      //delete user
      authCurrUser!.delete();
      //signIn with admin
      await fbAuth.signInWithEmailAndPassword(
        email: cUser.email!,
        password: cUser.pwd!,
      );
      print('## admin: <${authCurrUser!.email}> reSigned in');

    });




  }

  void fetchUser() {
    print('## AuthController fetching User ...');


    firebaseUser = Rx<User?>(fbAuth.currentUser);
    googleSignInAccount = Rx<GoogleSignInAccount?>(googleSign.currentUser);


    // its not called and not being disposed so if we click ggl signIn it detect a google user cz its always listening and give widget error
    // googleSignInAccount.bindStream(googleSign.onCurrentUserChanged);
    // workerGgl = ever(googleSignInAccount, _setInitialScreenGoogle);

    // this detect google and not-google users
    firebaseUser.bindStream(fbAuth.userChanges());
    worker = ever(firebaseUser, _setInitialScreen);

  }


  // need this once, that's why i dispose it at entrance
  _setInitialScreen(User? user) async {
    print('# _setInitialScreen');
    worker.dispose();


    // if(worker.disposed){
    //   print('## worker.disposed: ${worker.disposed}');
    // }
    if (user == null) {//no user found
      //print('## no user Found');
      print('## user == null');
      Get.offAll(() => Login());


    } else {//user who can be signed in found found
      print('## user != null');
      //print('## User stayed signed in >> ${user.email!}');
      await getUserInfoByEmail(user.email).then((value) {
        checkUserVerif(isLoadingScreen: true);
      });

    }
  }
  _setInitialScreenGoogle(GoogleSignInAccount? googleSignInAccount) async {
    print('# _setInitialScreenGoogle');
    workerGgl.dispose();


    if (googleSignInAccount == null) {
      print('## google-user == null');
      Get.offAll(() => Login());

    } else {
      //print('## google-User stayed signed in >> ${googleSignInAccount.email}');
      print('## google-user != null');

      await getUserInfoByEmail(googleSignInAccount.email).then((value) {
        checkUserVerif(isLoadingScreen: true);
      });
    }

  }

  Future<void> signInWithGoogle() async {
    try {
      print('## try to googleSignIn');


      GoogleSignInAccount?  googleAccount = await _googleSignIn.signIn()  ;
      //await _googleSignIn.signIn()  ;
      print('## GoogleSignIn().signIn() PASSED');
      showLoading(text: 'Connecting'.tr);


      // Future.delayed(const Duration(seconds: 5), () {
      //   print('## 5 sec done');
      // });


      ///if google_sign_in passed
      if (googleAccount != null) { // is a true ggl account
        //print('## googleAccount != null');

        final GoogleSignInAuthentication googleSignInAuthentication = await googleAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await fbAuth.signInWithCredential(credential).then((value) {}).catchError((onErr) => print('## google_onErr $onErr'));
        // try signIn or signUp with google
        await usersColl.where('email', isEqualTo: googleAccount.email).get().then((event) async {
          var userDocsLength = event.docs.length; // check if there is an account resistred in db with that email
          if(userDocsLength == 0){
            /// add new account
            print('## should create new google account');

            //Get.to(()=>Register(),arguments: {'name': googleAccount.displayName,'email':googleAccount.email});
            Get.to(() => SelectAccountType(),arguments: {'gglName': googleAccount.displayName,'gglEmail':googleAccount.email});

            //
            // addDocument(
            //     fieldsMap: {
            //       'name': googleAccount.displayName,
            //       'email': googleAccount.email,
            //       'pwd': 'this-is-google-user-pwd',
            //       'joinDate': todayToString(),
            //       'verified': true,
            //
            //       'isAdmin': false,
            //       'speciality': specialityTec.text,
            //       'age': ageTec.text,
            //       'address': addressTec.text,
            //       'number': phoneTec.text,
            //       'sex': sex,
            //       'role': isPatient ? 'patient' : 'doctor',
            //
            //       'doctorAttachedID': '',//pat <no-doc>
            //       'health': {},//pat
            //       'appointments': {},//doc
            //       'notifications': {},//doc
            //       'patients': [],//doc
            //     },
            //     collName: usersCollName
            // ).then((value) async {
            //   Future.delayed(const Duration(milliseconds: 3000), () async {
            //     await getUserInfoByEmail(googleAccount.email).then((value) {
            //       checkUserVerif(isGoogle: true);
            //     });
            //   });
            //
            // });

          }else{ // ggl account already registred
            print('## google account already registred');
            await getUserInfoByEmail(googleAccount.email).then((value) {
              checkUserVerif(isGoogle: true);
            });
          }
        });
      }
      else{
        //print('## googleAccount == null');
      }
      Get.back();
    } catch (e) {
      showTos("connection error".tr);
      print('## error while trying to sign in with ggl: $e');
    }
  }
  checkUserVerif({bool isGoogle =false,bool isLoadingScreen =false}) {
    print('## checking account verification...');

    if (cUser.verified) {
      print('## <account> verified > goHome');
      Get.offAll(()=>homePage());
    }
    else {
      print('## <account> NOT verified');
      if(!isGoogle) showShouldVerify(
          isLoadingScreen: isLoadingScreen
      );

    }
  }



  ///  AUTHEN ////////////////
  signIn(String _email, String _password,  {Function()? onSignIn}) async {
    try {
      print('## try to signIn');

      //try signIn
      await fbAuth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      )
          .then((value)  {
        //account found
        onSignIn!();


      });

      // signIn error
    } on FirebaseAuthException catch (e) {
      Get.back();

      print('## error signIn => ${e.message}');
      if (e.code == 'user-not-found') {
        showTos('User not found'.tr);
        print('## user not found');
      } else if (e.code == 'wrong-password') {
        showTos('Wrong password'.tr);

        print('## wrong password');
      }
    } catch (e) {
      Get.back();
      print('## catch err in signIn user_auth: $e');
    }
  }
  signUp(String _email, String _password, {Function()? onSignUp}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      )
          .then((value) {
        onSignUp!();
      });

    } on FirebaseAuthException catch (e) {
      print('## error signUp => ${e.message}');
      Get.back();

      if (e.code == 'weak-password') {
        showTos('Weak password'.tr);
        print('## weak password.');
      } else if (e.code == 'email-already-in-use') {
        showTos('Email already in use'.tr);
        print('## email already in use');
      }
    } catch (e) {
      Get.back();

      print('## catch err in signUp user_auth: $e');
    }
  }
  /// ///////





  streamingDoc(CollectionReference coll,String id){
    print('##_start_Streaming');

    if(id!=''){
      streamSub  = coll.where('id', isEqualTo: id).snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((change) {
          print('##_CHANGE_Streaming');

          var user = snapshot.docs.first;
          authCtr.cUser.patients = user.get('patients');
          authCtr.cUser.doctorAttachedID = user.get('doctorAttachedID');
          authCtr.cUser.notifications = user.get('notifications');
          authCtr.cUser.appointments = user.get('appointments');
          //getPatientsFromIDs(authCtr.cUser.patients!);
          Future.delayed(Duration(milliseconds: 20),(){update();});
        });
      });
    }else{
      print('##_no_ID_to_stream_yet');
    }



  }

  stopStreamingDoc(){
    streamSub.cancel();
    print('##_stop_Streaming');

  }



  void ResetPss(String email) async {
    try {
      await fbAuth.sendPasswordResetEmail(email: email).then((uid) {
        showTos('password reset has been sent to your mailbox'.tr);
        Get.back();
      }).catchError((e) {
        print('## catchError while ResetPss => $e');
        showTos('Enter a valid email'.tr);

      });
    } on FirebaseAuthException catch (e) {
      showTos('connection error'.tr);
      print('## Error sending reset pass' + e.message.toString());
    }
  }
  void signOut() async {
    await fbAuth.signOut();
    await googleSign.signOut();
    cUser = ScUser();
    //sharedPrefs!.setBool('isGuest', false);
    //Get.delete<AuthController>();
    //fetchUser();
    Get.offAll(()=>Login());
    print('## user signed out');
  }
  // send verif code screen
  Future<void> verifyUserEmail(timer) async {
    //user = authCurrUser!;
    await authCurrUser!.reload();
    if (authCurrUser!.emailVerified) {

      await usersColl.where('email', isEqualTo: authCurrUser!.email).get().then((event) {
        var userDoc = event.docs.single;
        String userID = userDoc.get('id');
        usersColl.doc(userID).update({
          'verified':true
        });


      });
      print('### account verified');
      timer.cancel();
      showTos('your account has been verified\nplease reconnect'.tr);
      Get.offAll(()=>Login());
    }
  }


  /// refresh user props from database
  refreshCuser() async {
    getUserInfoByEmail(authCtr.cUser.email);
    if(cUser.role=='patient') {
      ptCtr.myDoctor = await getUserByID(authCtr.cUser.doctorAttachedID);
      ptCtr.update();
    }
    if(cUser.role=='doctor') {
      dcCtr.getMyPatientsFromIDs(authCtr.cUser.patients);
      dcCtr.update();
    }
  }




  /// GET-USER-INFO VY PROP

  Future<void> getUserInfoByEmail(userEmail,{bool printDetails = true}) async {
    await usersColl.where('email', isEqualTo: userEmail).get().then((event) {
      var userDoc = event.docs.single;
      //print('## getiing <$userEmail> from db ...');
      cUser = ScUserFromMap(userDoc);
      // getPatientsFromIDs(authCtr.cUser.patients!);
      // Future.delayed(const Duration(milliseconds: 1500), () async {//time to start readin data
      //   //Get.find<DoctorHomeCtr>().update(['appBar']);
      //   Get.find<DoctorHomeCtr>().updateCtr();
      //   update();
      //
      // });

        if(printDetails) printUser(cUser);

    }).catchError((e) => print("## cant find user in db (email_search): $e"));


  }

  Future<void> getUserInfoByID(userID,{bool printDetails = true}) async {
    await usersColl.where('id', isEqualTo: userID).get().then((event) {
      var userDoc = event.docs.single;
      cUser = ScUserFromMap(userDoc);
      if(printDetails) printUser(cUser);

    }).catchError((e) => print("## cant find user in db (id_search): $e"));


  }


}
