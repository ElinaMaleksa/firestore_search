library firestore_search;

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService<T> {
  final String? collectionName;
  final String? searchBy;
  final String? docUIDSearchBy;
  final List Function(QuerySnapshot)? dataListFromSnapshot;
  final int? limitOfRetrievedData;

  FirestoreService(
      {this.collectionName, this.searchBy, this.docUIDSearchBy, this.dataListFromSnapshot, this.limitOfRetrievedData});

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Stream<List> searchData(String query) {
    final collectionReference = firebaseFirestore.collection(collectionName!);
    return query.isEmpty
        ? Stream.empty()
        : docUIDSearchBy?.isEmpty ?? true
            ? collectionReference
                .orderBy('$searchBy', descending: false)
                .where('$searchBy', isGreaterThanOrEqualTo: query)
                .where('$searchBy', isLessThan: query + 'z')
                .limit(limitOfRetrievedData!)
                .snapshots()
                .map(dataListFromSnapshot!)
            : collectionReference
                .orderBy('$searchBy', descending: false)
                .where(FieldPath.documentId, whereIn: [docUIDSearchBy])
                .limit(limitOfRetrievedData!)
                .snapshots()
                .map(dataListFromSnapshot!);
  }
}
