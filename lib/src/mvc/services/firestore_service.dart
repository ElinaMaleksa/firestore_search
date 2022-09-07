library firestore_search;

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService<T> {
  final String? collectionName;
  final String? searchBy;
  final List Function(QuerySnapshot)? dataListFromSnapshot;
  final int? limitOfRetrievedData;

  FirestoreService({this.collectionName, this.searchBy, this.dataListFromSnapshot, this.limitOfRetrievedData});

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Stream<List> searchData(String query) {
    final collectionReference = firebaseFirestore.collection(collectionName!);
    print("searchBy == uid: ${searchBy == "uid"}");
    print("QUERY: $query");
    return query.isEmpty
        ? Stream.empty()
        : searchBy == "uid"
            ? collectionReference
                .where(FieldPath.documentId, isEqualTo: query)
                .snapshots()
                .map(dataListFromSnapshot!)
            : collectionReference
                .orderBy('$searchBy', descending: false)
                .where('$searchBy', isGreaterThanOrEqualTo: query)
                .where('$searchBy', isLessThan: query + 'z')
                .limit(limitOfRetrievedData!)
                .snapshots()
                .map(dataListFromSnapshot!);
  }
}
