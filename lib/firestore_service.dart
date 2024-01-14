import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tic_tac_toe/game_state.dart';

class FirestoreService {
  final String docID;

  FirestoreService({required this.docID});

  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('0000');

  Stream<DocumentSnapshot<Map<String, dynamic>>> gameStream() {
    return _collection.doc(docID).snapshots()
        as Stream<DocumentSnapshot<Map<String, dynamic>>>;
  }

  Future<GameState> getGame() async {
    var res = await _collection.doc(docID).get();
    return GameState.fromJson(res.data() as Map<String, dynamic>);
  }

  Future<void> addData(dynamic data) async {
    try {
      print(data);
      var res = await _collection.doc(docID).set(data);

      print("Data added successfully");
    } catch (e) {
      print("Error adding data: $e");
    }
  }

  Future<void> updateData(dynamic data) async {
    try {
      await _collection.doc(docID).update(data);
      print("Data updated successfully");
    } catch (e) {
      print("Error updating data: $e");
    }
  }
}
