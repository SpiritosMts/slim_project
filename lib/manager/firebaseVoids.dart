

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'myVoids.dart';
import 'dart:io';

Future<List<String>> getChildrenKeys(String ref) async {
  List<String> children = [];
  DatabaseReference serverData = database!.ref(ref);//'patients/sr1'
  final snapshot = await serverData.get();
  if (snapshot.exists) {
    snapshot.children.forEach((element) {
      children.add(element.key.toString());
    });
    //print('## <$ref> exists with [${children.length}] children');
  } else {
    //print('## <$ref> DONT exists');
  }
  return children;
}
Future<int> getChildrenNum(String ref) async {
  int childrennum = 0;
  DatabaseReference serverData = database!.ref(ref);//'patients/sr1'
  final snapshot = await serverData.get();
  if (snapshot.exists) {
    childrennum = snapshot.children.length;
    print('## <$ref> exists with [${childrennum}] children');
  } else {
    print('## <$ref> DONT exists');
  }
  //update(['chart']);
  return childrennum;
}



/// upload one file to fb
Future<String> uploadOneImgToFb(String filePath, PickedFile? imageFile) async {
  if (imageFile != null) {
    String fileName = path.basename(imageFile.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/$filePath/$fileName');

    File img = File(imageFile.path);

    final metadata = firebase_storage.SettableMetadata(contentType: 'image/jpeg', customMetadata: {
      // 'picked-file-path': 'picked000',
      // 'uploaded_by': 'A bad guy',
      // 'description': 'Some description...',
    });
    firebase_storage.UploadTask uploadTask = ref.putFile(img, metadata);

    String url = await (await uploadTask).ref.getDownloadURL();
    print('  ## uploaded image');

    return url;
  } else {
    print('  ## cant upload null image');
    return '';
  }
}

/// add DOCUMENT to fireStore
Future<void> addDocument({required fieldsMap ,required String collName , bool addID=true, bool addRealTime=false, String docPathRealtime='',Map<String,dynamic>? realtimeMap}) async {
  CollectionReference coll = FirebaseFirestore.instance.collection(collName);

  // Map fields={
  //   'name': nameController.text,
  //   'email': emailController.text,
  //   'pwd': passwordController.text,
  //   //'verified':false,
  //   'garages': [],
  // };

  coll.add(fieldsMap).then((value) async {
    print("## DOC ADDED TO <$collName>");

    //add id to doc
    if(addID){
      String docID = value.id;
      //set id
      coll.doc(docID).update({ ///this
        'id': docID,
      },
        //SetOptions(merge: true),
      );
      if(addRealTime){
        DatabaseReference serverData = database!.ref(docPathRealtime);
        await serverData.update({
          "$docID": realtimeMap
        }).then((value) async {
        });
      }

    }

  }).catchError((error) {
    print("## Failed to add doc to <$collName>: $error");
  });
}


/// delete by url
Future<void> deleteFileByUrlFromStorage(String url) async {
  try {
    await FirebaseStorage.instance.refFromURL(url).delete();
  } catch (e) {
    print("Error deleting file: $e");
  }
}

Future<void> addElementsToList(List newElements, String fieldName, String docID, String collName,{bool canAddExistingElements=true}) async {
  print('## start adding list <$newElements> TO <$fieldName>_<$docID>_<$collName>');

  CollectionReference coll = FirebaseFirestore.instance.collection(collName);

  coll.doc(docID).get().then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      // export existing elements
      List<dynamic>  oldElements = documentSnapshot.get(fieldName);
      print('## oldElements: $oldElements');
      // element to add
      List<dynamic>  elementsToAdd = [] ;
      if(canAddExistingElements){
        elementsToAdd = newElements;
      }else{
        for (var element in newElements) {
          if(!oldElements.contains(element)){
            elementsToAdd.add(element);
          }
        }
      }

      print('## elementsToAdd: $elementsToAdd');
      // add element
      List<dynamic> newElementList = oldElements + elementsToAdd;
      print('## newElementListMerged: $newElementList');

      //save elements
      await coll.doc(docID).update(
        {
          fieldName: newElementList,
        },
      ).then((value) async {
        print('## successfully added list <$elementsToAdd> TO <$fieldName>_<$docID>_<$collName>');
      }).catchError((error) async {
        print('## failure to add list <$elementsToAdd> TO <$fieldName>_<$docID>_<$collName>');
      });
    }else if (!documentSnapshot.exists) {
      print('## docID not existing');
    }
  });
}
Future<void>  removeElementsFromList(List elements, String fieldName, String docID, String collName) async {
  print('## start deleting list <$elements>_<$fieldName>_$docID>_<$collName>');

  CollectionReference coll = FirebaseFirestore.instance.collection(collName);

  coll.doc(docID).get().then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      // export existing elements
      List<dynamic>  oldElements = documentSnapshot.get(fieldName);
      print('## oldElements:(before delete) $oldElements');

      // remove elements from oldElements
      List<dynamic>  elementsRemoved = [];

      for (var element in elements) {
        if(oldElements.contains(element)){
          oldElements.removeWhere((e) => e==element);
          elementsRemoved.add(element);
          //print('# removed <$element> from <$oldElements>');

        }
      }

      print('## oldElements:(after delete) $oldElements');
      await coll.doc(docID).update(
        {
          fieldName: oldElements,
        },
      ).then((value) async {
        print('## successfully deleted list <$elementsRemoved> FROM <$fieldName>_<$docID>_<$collName>');
      }).catchError((error) async {
        print('## failure to delete list <$elementsRemoved> FROM  <$fieldName>_<$docID>_<$collName>');
      });
    }else if (!documentSnapshot.exists) {
      print('## docID not existing');
    }
  });
}

Future<void> emptyItemStringFromCloud(String fieldName, String docID, String collName)async{
  CollectionReference coll = FirebaseFirestore.instance.collection(collName);

  coll.doc(docID).update(
    {
      fieldName: '',
    },
  );
}

// test()  {
//
//   Map<String, dynamic> mapToAdd = {
//     'item': 'test'
//   };
//
//   testColl.add(mapToAdd).then((value) async {
//     String docID = value.id;
//     testColl.doc(docID).update({
//       'id': docID,
//     });
//     print("### doc added with id:<$docID>");
//   }).catchError((e) async {
//     print("## Failed to add document: $e");
//   });
// }

addDoc(CollectionReference coll) async {

  Map<String, dynamic> mapToAdd = {
    'null': null,
    'string': 'hajime',
    'number': 4.5,
    'geopoint': const GeoPoint(0.1,4.5),
    //'reference': 'ref',
    'map': {
      'key0':'value0',
      'key1':'value1',
      'key2':'value2',
    },
    'list':[
      'item0',
      'item1',
      'item2',
    ]
  };

  coll.add(mapToAdd).then((value) async {
    String docID = value.id;
    coll.doc(docID).update({
      'id': docID,
    });
    print("### doc added with id:<$docID>");
  }).catchError((e) async {
    print("## Failed to add document: $e");
  });
}
// updateDoc(CollectionReference coll,docID,Map<String, dynamic> mapToUpdate) async {
//   // Map<String, dynamic> mapToUpdate = {
//   //   'null': null,
//   //   'string': 'hh',
//   //   'number': 4.5,
//   //   'geopoint': const GeoPoint(0.1,4.5),
//   //   'map': {
//   //     'key0':'value0',
//   //     'key1':'value1',
//   //     'key2':'value2',
//   //   },
//   //   'list':[
//   //     'item0',
//   //     'item1',
//   //     'item2',
//   //   ]
//   // };
//
//   coll.doc(docID).update(mapToUpdate).then((value) async {
//
//     print("### doc with id:<$docID> updated ");
//   }).catchError((e) async {
//     print("## Failed to update document: $e");
//   });
// }
getDocProps(CollectionReference coll,docID)async{
  await coll.doc(docID).get().then((docSnap) {
    num number = docSnap.get('number');
    GeoPoint geoPoint = docSnap.get('geopoint');
    String string = docSnap.get('string');
    Map<String,dynamic> map = docSnap.get('map');
    List list = docSnap.get('list');
    var nullVar = docSnap.get('null');

  }).catchError((e)=>print('## error getting doc with id <$docID>'));




}



clearCollection(CollectionReference coll)async{
  var snapshots = await coll.get();
  for (var doc in snapshots.docs) {
    print('# delete doc<${doc.id}>');
    await doc.reference.delete();
  }
}



Future<List<String>> getDocumentsIDsByFieldName(String fieldName, String filedValue,CollectionReference coll) async {
  QuerySnapshot snap = await coll
      .where(fieldName, isEqualTo: filedValue) //condition
      .get();

  List<String> docsIDs = [];
  final List<DocumentSnapshot> documentsFound = snap.docs;
  for (var doc in documentsFound) {
    docsIDs.add(doc.id);
  }
  print('## docs has [$fieldName=$filedValue] =>$docsIDs');

  return docsIDs;
}

Future<List<DocumentSnapshot>> getDocumentsByColl(CollectionReference coll) async {
  QuerySnapshot snap = await coll.get();

  final List<DocumentSnapshot> documentsFound = snap.docs;

  print('## collection:<${coll.path}> docs length =(${documentsFound.length})');

  return documentsFound;
}

Future<List<DocumentSnapshot>> getDocumentsByCollCondition(CollectionReference coll,{bool onlyAccepted = false,bool onlyOwned = false,}) async {

 // List userStoresIDs = authCtr.cUser.stores!;
  List userStoresIDs = [];
  QuerySnapshot snap = onlyOwned? await coll.where('id',whereIn: userStoresIDs).get() :(onlyAccepted? await coll.where('accepted',isEqualTo: 'yes').get():await coll.get());

  final List<DocumentSnapshot> documentsFound = snap.docs;

  print('## collection:<${coll.path}> docs length =(${documentsFound.length})');

  return documentsFound;
}

Future<bool> checkDocExist(String docID, coll) async {
  var docSnapshot = await coll.doc(docID).get();

  if(docSnapshot.exists){
    print('## docs with id=<$docID> exists');
  }
  else{
    print('## docs with <id=$docID> NOT exists');

  }
  return docSnapshot.exists;
}

/// Check If Document Exists
Future<bool> checkIfDocExists(String collName, String docId) async {
  try {
    // Get reference to Firestore collection
    var collectionRef = FirebaseFirestore.instance.collection(collName);

    var doc = await collectionRef.doc(docId).get();
    return doc.exists;
  } catch (e) {
    throw e;
  }
}

deleteUser(String userID) {
  usersColl.doc(userID).delete().then((value) async {
    print('## user deleted');
    //removeUserServers(userID);
    showSnack('user deleted'.tr,color: Colors.redAccent.withOpacity(0.8));
  }).catchError((error) async {
    print('## user deleting error = ${error}');
    //showSnack('doctor accepted');
  });
  ;
}

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
      email: authCtr.cUser.email!,
      password: authCtr.cUser.pwd!,
    );
    print('## admin: <${authCurrUser!.email}> reSigned in');

  });

}
acceptUser(String userID) {
  usersColl.doc(userID).get().then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      await usersColl.doc(userID).update({
        'accepted': true, // turn verified to true in  db
      }).then((value) async {
        //addFirstServer(userID);
        print('## user request accepted');
        showSnack('doctor request accepted'.tr);

      }).catchError((error) async {
        print('## user request accepted accepting error =${error}');
        //toastShow('user request accepted accepting error');
      });
    }
  });
}

changeUserName(newName) async {
  await usersColl.doc(authCtr.cUser.id).get().then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      await usersColl.doc(authCtr.cUser.id).update({
        'name': newName, // turn verified to true in  db
      }).then((value) async {
        showSnack('name updated'.tr);
        //refreshUser(currentUser.email);
        //Get.back();//cz it in dialog
      }).catchError((error) async {
        //print('## user request accepted accepting error =${error}');
        //toastShow('user request accepted accepting error');
      });
    }
  });
}
changeUserEmail(newEmail) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      // Change email
      await user.updateEmail(newEmail).then((value){
        usersColl.doc(authCtr.cUser.id).get().then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            await usersColl.doc(authCtr.cUser.id).update({
              'email': newEmail, // turn verified to true in  db
            }).then((value) async {
              print('## email firestore updated');
              showSnack('email updated');
              //refreshUser(_emailController.text);
            }).catchError((error) async {
            });
          }
        });
      });



    } catch (e) {

      showSnack('This operation is sensitive and requires recent authentication.\n Log in again before retrying this request',color: Colors.black54);
      print('## Failed 4to update email:===> $e');
    }
  }
}

changeUserPassword(newPassword) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {


      // Change password
       await user.updatePassword(newPassword).then((value){
        usersColl.doc(authCtr.cUser.id).get().then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists) {
            await usersColl.doc(authCtr.cUser.id).update({
              'pwd': newPassword, // turn verified to true in  db
            }).then((value) async {
              showSnack('password updated');
              //refreshUser(currentUser.email);

            }).catchError((error) async {
            });
          }
        });
      });



    } catch (e) {

      showSnack('This operation is sensitive and requires recent authentication.\n Log in again before retrying this request',color: Colors.black54);

      print('## Failed to update password:===> $e');
    }
  }
}