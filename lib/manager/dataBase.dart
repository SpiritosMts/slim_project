

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

Future<List<DocumentSnapshot>> getDocumentsByColl(coll) async {
  QuerySnapshot snap = await coll.get();

  final List<DocumentSnapshot> documentsFound = snap.docs;

  print('## collection docs number => (${documentsFound.length})');

  return documentsFound;
}

Future<void> removeElementsFromList(
    List elements, String fieldName, String docID, String collName) async {
  print('## start deleting list <$elements>_<$fieldName>_<$docID>_<$collName>');

  CollectionReference coll = FirebaseFirestore.instance.collection(collName);

  coll.doc(docID).get().then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      // export existing elements
      List<dynamic> oldElements = documentSnapshot.get(fieldName);
      print('## oldElements:(before delete) $oldElements');

      // remove elements from oldElements
      List<dynamic> elementsRemoved = [];

      for (var element in elements) {
        if (oldElements.contains(element)) {
          oldElements.removeWhere((e) => e == element);
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
        print(
            '## successfully deleted list <$elementsRemoved> FROM <$fieldName>_<$docID>_<$collName>');
      }).catchError((error) async {
        print(
            '## failure to delete list <$elementsRemoved> FROM  <$fieldName>_<$docID>_<$collName>');
      });
    } else if (!documentSnapshot.exists) {
      print('## docID not existing');
    }
  });
}

Future<void> addElementsToList(
    List newElements, String fieldName, String docID, String collName,
    {bool canAddExistingElements = true}) async {
  print(
      '## start adding list <$newElements> TO <$fieldName>_<$docID>_<$collName>');

  CollectionReference coll = FirebaseFirestore.instance.collection(collName);

  coll.doc(docID).get().then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      // export existing elements
      List<dynamic> oldElements = documentSnapshot.get(fieldName);
      print('## oldElements: $oldElements');
      // element to add
      List<dynamic> elementsToAdd = [];
      if (canAddExistingElements) {
        elementsToAdd = newElements;
      } else {
        for (var element in newElements) {
          if (!oldElements.contains(element)) {
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
        print(
            '## successfully added list <$elementsToAdd> TO <$fieldName>_<$docID>_<$collName>');
      }).catchError((error) async {
        print(
            '## failure to add list <$elementsToAdd> TO <$fieldName>_<$docID>_<$collName>');
      });
    } else if (!documentSnapshot.exists) {
      print('## docID not existing');
    }
  });
}

updateDoc(
    CollectionReference coll, docID, Map<String, dynamic> mapToUpdate) async {
  coll.doc(docID).update(mapToUpdate).then((value) async {
    print("### doc with id:<$docID> updated ");
  }).catchError((e) async {
    print("## Failed to update document: $e");
  });
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