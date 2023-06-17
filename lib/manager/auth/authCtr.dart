

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_care/_doctor/home/doctorHome_ctr.dart';
import 'package:smart_care/manager/auth/login.dart';
import 'package:smart_care/manager/auth/register.dart';
import 'package:smart_care/manager/auth/registerSelectType.dart';
import 'package:smart_care/manager/firebaseVoids.dart';
import 'package:smart_care/manager/myVoids.dart';

import '../../_doctor/notifications/awesomeNotif.dart';
import '../../_patient/home/patientHome_ctr.dart';
import '../../chart_live_history/chart_live_history_ctr.dart';
import '../../main.dart';
import '../../models/user.dart';


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: '133617459544-illi26s99ha8l5uo958drtbi529qo6r6.apps.googleusercontent.com',//web
 // clientId: '133617459544-ahriq2de0u90fs8n3msmrhkbqh60c2jc.apps.googleusercontent.com',//web
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
      listenToChat();
      listenToAppoi();
      //streamingDoc(usersColl,'Y1nMifjP7ga7lTNW4pZd');
    });
  }
  @override
  void onClose() {
    super.onClose();
    stopStreamingDoc();
    chatStream!.cancel();
    appoiStream!.cancel();

  }

  /// //////////////////////////////////////////////////////////////////:






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
      if (googleAccount != null) {
        // is a true ggl account
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
            Get.back();
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
        Get.back();

        //print('## googleAccount == null');
      }
      //Get.back();
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
    Get.delete<DoctorHomeCtr>();
    Get.delete<PatientHomeCtr>();
    Get.delete<ChartsCtr>();

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
    print('## refreshing user .....');
    getUserInfoByEmail(authCtr.cUser.email);
    if(cUser.role=='patient') {
      //ptCtr.myDoctor = await getUserByID(authCtr.cUser.doctorAttachedID!);
      ptCtr.update();
    }
    if(cUser.role=='doctor') {
      dcCtr.update();
    }
  }




  /// GET-USER-INFO VY PROP

  Future<void> getUserInfoByEmail(userEmail,{bool printDetails = true}) async {
    print('## getting user info by email ...  ##');

    await usersColl.where('email', isEqualTo: userEmail).get().then((event) async {
      var userDoc = event.docs.single;
      cUser = ScUserFromMap(userDoc);
      printUser(cUser);

      //Get.put<ChartsCtr>(ChartsCtr());

      // if(cUser.role=='patient') {
      //   print('## connected-user is < patient >##');
      //   //Get.put<PatientHomeCtr>(PatientHomeCtr());
      // }
      // if(cUser.role=='doctor') {
      //   print('## connected-user is < doctor > ##');
      //   //Get.put<DoctorHomeCtr>(DoctorHomeCtr());
      // }
        //if(printDetails) printUser(cUser);

    }).catchError((e) => print("## cant find user in db (email_search): $e"));


  }

  Future<void> getUserInfoByID(userID,{bool printDetails = true}) async {
    await usersColl.where('id', isEqualTo: userID).get().then((event) {
      var userDoc = event.docs.single;
      cUser = ScUserFromMap(userDoc);
      //if(printDetails) printUser(cUser);

    }).catchError((e) => print("## cant find user in db (id_search): $e"));


  }
  /// /////////// STREAM ////////////////////////
  bool firstNotifBlocked = false;
  StreamSubscription? chatStream;
  StreamSubscription? appoiStream;
  int appoiLocalNum =0;
  int appoiOnlineNum =0;
  bool showAcceptance =true;
  bool firstSend =true;
  Map<String, dynamic> messages ={};
  Map<String, dynamic> doctorAppoi ={};

  void listenToChat() {
    chatStream = FirebaseFirestore.instance
        .collection('sc_rooms')
        .doc('JVNpE4BoC7iN90dxpzK3fuxNHBtnC1TmCbmgSjkH')
        .snapshots()
        .map((snapshot) => snapshot.data() as Map<String, dynamic>)
        .listen((data) async {
      // Access the map data using data['key']
      messages = data['messages'];
      print('## messages<${messages.length}>: $messages');
      if(messages.isNotEmpty){
        Map<String, dynamic> msg = messages[(messages.length - 1).toString()];
        String sender = msg['sender'];
        String contain = msg['msg'];
        if (sender != authCtr.cUser.name) {
          print('## receive new msg');
          if(!firstSend) {
            NotificationController.createNewStoreNotification('${sender}', '${contain}');

          }else{
            firstSend =false;
          }
        }
      }

      //update();
    });
  }
  void listenToAppoi() {
    appoiLocalNum = sharedPrefs!.getInt('appoi')??0 ;
    print('## init appoiLocalNum = <$appoiLocalNum>');

    appoiStream = FirebaseFirestore.instance
        .collection('sc_users')
        .doc('JVNpE4BoC7iN90dxpzK3')
        .snapshots()
        .map((snapshot) => snapshot.data() as Map<String, dynamic>)
        .listen((data) async {
      // Access the map data using data['key']
      doctorAppoi = data['appointments'];
      appoiOnlineNum = doctorAppoi.length;
      print('## appoiOnlineNum = <$appoiOnlineNum>');


      //print('## appoitments<${doctorAppoi.length}>: $doctorAppoi');
      if(doctorAppoi.isNotEmpty && doctorAppoi['fuxNHBtnC1TmCbmgSjkH'] != null){

        var appoi = doctorAppoi['fuxNHBtnC1TmCbmgSjkH'];
        String sender = appoi['patientName'];
        String time = appoi['time'];

        if (authCtr.cUser.role == 'doctor') {
          if(appoiOnlineNum == appoiLocalNum + 1){
            print('## receive new appoi');
            sharedPrefs!.setInt('appoi', appoiOnlineNum);
            appoiLocalNum = appoiOnlineNum;
            NotificationController.createNewStoreNotification('${sender}', 'want to schedule a meeting at ${time}');
          }
        }else{
          if(showAcceptance){
            for (var key in doctorAppoi.keys) {
              if (key == authCtr.cUser.id) {
                Map<String, dynamic> patAppoi = doctorAppoi[key];
                if (patAppoi['new'] == false) {

                  NotificationController.createNewStoreNotification('${authCtr.cUser.name}', 'your doctor has accepted your meeting request');
                  showAcceptance=false;
                }
              }
            }
          }
        }
      }

      //update();
    });
  }

  // void listenToUserChanges()async{
  //   print('## start stream listening...');
  //
  //
  //
  //   myStream =  FirebaseFirestore.instance.collection('sc_rooms')
  //       .doc(authCtr.cUser.id).snapshots().listen((event)  {
  //
  //     if(firstNotifBlocked){
  //       for (var change in event.docChanges) {
  //
  //         bool newStore=false;
  //         switch (change.type) {
  //           case DocumentChangeType.added:
  //             print("## added Store To NotifColl");
  //             newStore =true;
  //             break;
  //           case DocumentChangeType.modified:
  //             print("## modified Store To NotifColl");
  //             break;
  //           case DocumentChangeType.removed:
  //             print("## Removed Store To NotifColl");
  //             break;
  //         }
  //
  //         //
  //         DocumentSnapshot<Map<String, dynamic>> changedDoc = change.doc;
  //         Map<String, dynamic> notifications = changedDoc["notifications"];
  //
  //
  //         String body() {
  //           String product = notifications[(notifications.length-1).toString()]['product'];
  //           String productPrice = notifications[(notifications.length-1).toString()]['productPrice'];
  //           String storeName = changedDoc['storeName'];
  //           String message='';
  //           switch (product) {
  //             case "_STORE":
  //               message = 'تحقق من "${storeName}" واكتشف أفضل المنتجات والخدمات العربية';
  //               break;
  //
  //             default:
  //               message = 'احصل على "$product" من "$storeName" مقابل "$productPrice"';
  //           }
  //
  //           return message;
  //         }
  //         String title ='${changedDoc['storeName']}';
  //
  //         Notif newNotif =Notif(
  //           userId: '',//won't use
  //           storeId: changedDoc['id'],
  //           storeName: changedDoc['storeName'],
  //           lat: changedDoc['lat'],
  //           lng: changedDoc['lng'],
  //           body: body(),
  //           title: title,
  //           //get last notif
  //           end: notifications[(notifications.length-1).toString()]['end'],
  //           start: notifications[(notifications.length-1).toString()]['start'],
  //           product: notifications[(notifications.length-1).toString()]['product'],
  //         );
  //
  //         if(distanceToStore <= range){
  //           // maybe await for few seconds to update al fields once
  //           print('## user IN advertising range : distance(${distanceToStore}) < range($range)');
  //           streamedStores = updateStorePrefsListen(newNotif.storeId);
  //           NotificationController.createNewStoreNotification(newNotif.title!,newNotif.body!);
  //           addBGNotifToPrefs(newNotif);//add notif to prefs
  //         }else{
  //           print('## user NOT IN advertising range : distance(${distanceToStore}) > range($range)');
  //           streamedStores = updateStorePrefsListen(newNotif.storeId,remove: true);
  //         }
  //       }
  //     }else{
  //       firstNotifBlocked=true;
  //       print('##first_notif_blocked');
  //     }
  //
  //   },onError: (error) => print("## Listen To NOtif Failed failed: $error"),
  //   );
  //   //userStream!.cancel();
  // }


}
