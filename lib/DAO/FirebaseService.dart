import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../Model/BaseModel.dart';

class FirebaseService<T extends BaseModel> {
  late BaseModel model;

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  FirebaseStorage storageInstance = FirebaseStorage.instance;

  Future<T?> getDocumentById(String id) async {
    CollectionReference ref = firestoreInstance.collection(model.tableName);
    try {
      DocumentSnapshot<Object?> doc = await ref.doc(id).get();
      BaseModel resultObj = model;

      if (doc.exists) {
        resultObj.toObject(doc.id, doc.data());
      } else {
        return null;
      }

      return resultObj as T;
    } catch (e) {
      print("Error occurred while retrieving document : $e");
    }
    return null;
  }

  Future<List<T>> getCollection({Map<String, dynamic>? paramMap, Map<String, String>? idMap}) async {
    CollectionReference? ref;
    Query? query;
    try {
      List<String> idList = [];
      List<String> tableList = [];

      List<T> resultList = [];

      if (model.containsParent && idMap == null) throw Exception("Model contains parent but parentId supplied is null");

      this._findParent(baseModel: model.parentModel, idList: idList, tableList: tableList);

      for (int i = tableList.length - 1; -1 < i; i--) {
        if (ref == null) {
          ref = firestoreInstance.collection(tableList[i]);
        } else {
          String tableName = tableList[i + 1];
          ref = ref.doc(idMap![tableName]).collection(tableList[i]);
        }
      }

      if (ref == null) {
        ref = firestoreInstance.collection(model.tableName);
      } else {
        ref = ref.doc(idMap![tableList[0]]).collection(model.tableName);
      }

      if (paramMap != null) {
        Iterator it = paramMap.entries.iterator;

        while (it.moveNext()) {
          MapEntry entry = it.current;
          query = ref.where(entry.key, isEqualTo: entry.value);
        }
      }

      QuerySnapshot<Object?> col = await (query != null ? query.get() : ref.get());

      if (col.size > 0) {
        Iterator it = col.docs.iterator;

        BaseModel resultModel = this.model;

        while (it.moveNext()) {
          BaseModel resultObj = resultModel;

          DocumentSnapshot<Object?> doc = it.current;

          resultObj.toObject(doc.id, doc.data());

          resultList.add(resultObj as T);
        }
      }

      return resultList;
    } catch (e, sT) {
      print("Error occurred while retrieving document : $e");
      print(sT);
    }
    return [];
  }

  Future create(T model) async {
    DocumentReference? ref;
    try {
      List<String> idList = [];
      List<String> tableList = [];

      if (model.containsParent) this._findParent(baseModel: model.parentModel, idList: idList, tableList: tableList);

      model.creationTime = DateTime.now();
      model.updateTime = DateTime.now();

      for (int i = tableList.length - 1; -1 < i; i--) {
        if (ref == null) {
          ref = firestoreInstance.collection(tableList[i]).doc(idList[i]);
        } else {
          ref = ref.collection(tableList[i]).doc(idList[i]);
        }
      }

      if (ref == null) {
        ref = firestoreInstance.collection(model.tableName).doc(model.id);
      } else {
        ref = ref.collection(model.tableName).doc(model.id);
      }

      await ref.set(model.toMap());
    } catch (e) {
      print("Error occurred while creating document : $e");
    }
  }

  Future save(T model) async {
    DocumentReference? ref;
    try {
      List<String> idList = [];
      List<String> tableList = [];

      if (model.containsParent) this._findParent(baseModel: model.parentModel, idList: idList, tableList: tableList);

      model.updateTime = DateTime.now();

      for (int i = tableList.length - 1; -1 < i; i--) {
        if (ref == null) {
          ref = firestoreInstance.collection(tableList[i]).doc(idList[i]);
        } else {
          ref = ref.collection(tableList[i]).doc(idList[i]);
        }
      }

      if (ref == null) {
        ref = firestoreInstance.collection(model.tableName).doc(model.id);
      } else {
        ref = ref.collection(model.tableName).doc(model.id);
      }

      await ref.update(model.toMap());
    } catch (e) {
      print("Error occurred while creating document : $e");
    }
  }

  Future<Uint8List?> downloadFile({required String filePath}) async {
    Reference storageRef = storageInstance.ref("/${model.tableName}");
    try {
      return await storageRef.child(filePath).getData();
    } catch (e) {
      print("Error occurred while downloading file : $e");
    }
    return null;
  }

  _findParent({BaseModel? baseModel, required List<String> idList, required List<String> tableList}) {
    if (baseModel != null) {
      idList.add(baseModel.id ?? "");
      tableList.add(baseModel.tableName);

      if (baseModel.containsParent && baseModel.parentModel != null) _findParent(baseModel: baseModel.parentModel, idList: idList, tableList: tableList);
    } else {
      throw NullThrownError();
    }
  }
}
