import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final String path;
  var ref;
  String endAt;

  static const COL = "COL";
  static const DOC = "DOC";

  FirebaseService(this.path) {
    var fullCollection;
    if (path.contains("/")) {
      List pathArray = path.split("/");
      for (int i = 0; i < pathArray.length; i++) {
        if(i == 0) {
          fullCollection = db.collection(pathArray.elementAt(i));
        } else {
          if(i % 2 == 0) {
            fullCollection = fullCollection.collection(pathArray.elementAt(i));
            this.endAt = COL;
          } else {
            fullCollection = fullCollection.doc(pathArray.elementAt(i));
            this.endAt = DOC;
          }
        }
      }
    } else {
      fullCollection = db.collection(path);
    }
    ref = fullCollection;
  }

  Future<dynamic> getData() {
    if(endAt == COL) {
      return getCollection();
    } else if (endAt == DOC) {
      return getDocument();
    } else {
      return null;
    }
  }

  Future<QuerySnapshot> getCollection() {
    return ref.get();
  }

  Future<DocumentSnapshot> getDocument() {
    return ref.get();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }
}
