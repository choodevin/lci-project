import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../Model/BaseModel.dart';

class FirebaseService {
  CollectionReference? ref;
  Reference? storageRef;

  BaseModel objectModel;

  BaseModel? subObject;

  FirebaseService.firestore(this.objectModel) {
    this.ref = FirebaseFirestore.instance.collection(objectModel.tableName);
  }

  FirebaseService.storage(this.objectModel) {
    this.storageRef = FirebaseStorage.instance.ref("/${objectModel.tableName}");
  }

  FirebaseService subCollection(BaseModel subObject, {String? parentId}) {
    if (ref != null) {
      if (parentId != null) {
        this.ref = this.ref!.doc(parentId).collection(subObject.tableName);
      } else {
        if (this.subObject == null) {
          this.ref = this.ref!.doc(objectModel.id).collection(subObject.tableName);
        } else {
          this.ref = this.ref!.doc(this.subObject!.id).collection(subObject.tableName);
        }
      }
      this.subObject = subObject;
    } else {
      throw Exception("Firestore reference is null");
    }

    return this;
  }

  // firestore method
  Future<dynamic>? getDocumentById(String id) async {
    if (ref != null) {
      try {
        DocumentSnapshot<Object?> doc = await ref!.doc(id).get();
        var resultObj = this.objectModel;

        if (doc.exists) {
          resultObj.toObject(doc.id, doc.data());
        } else {
          return null;
        }

        return resultObj;
      } catch (e) {
        print("Error occurred while retrieving document : $e");
      }
    } else {
      throw Exception("Collection reference is null, please verify if you are using firestore or storage");
    }

    return null;
  }

  // firestore method
  Future<List<dynamic>?> getCollection() async {
    if (ref != null) {
      try {
        QuerySnapshot<Object?> col = await ref!.get();

        List<dynamic> resultList = [];

        if (col.size > 0) {
          Iterator it = col.docs.iterator;

          while (it.moveNext()) {
            BaseModel resultObj = this.objectModel;

            DocumentSnapshot<Object?> doc = it.current;

            resultObj.toObject(doc.id, doc.data());

            resultList.add(resultObj);
          }
        }

        return resultList;
      } catch (e) {
        print("Error occurred while retrieving collection : $e");
      }
    } else {
      throw Exception("Collection reference is null, please verify if you are using firestore or storage");
    }

    return null;
  }

  // firestore method
  Future<bool> createDocument({String? id}) async {
    if (ref != null) {
      try {
        BaseModel toSaveObject;

        if (this.subObject != null)
          toSaveObject = this.subObject!;
        else
          toSaveObject = this.objectModel;

        toSaveObject.creationTime = DateTime.now();
        toSaveObject.updateTime = DateTime.now();

        Map<String, dynamic> doc = toSaveObject.toMap();

        if (id != null) {
          await ref!.doc(id).set(doc);
          toSaveObject.id = id;
        } else if (toSaveObject.id != null) {
          await ref!.doc(toSaveObject.id).set(doc);
        } else {
          await ref!.add(doc).then((doc) => toSaveObject.id = doc.id);
        }

        return true;
      } catch (e) {
        print("Error occurred while creating document : $e");
        return false;
      }
    } else {
      throw Exception("Collection reference is null, please verify if you are using firestore or storage");
    }
  }

  Future<List<dynamic>?> getDocumentByFieldValue(Map<String, dynamic> paramMap) async {
    if (ref != null) {
      try {
        Iterator it = paramMap.entries.iterator;
        List<dynamic> resultList = [];

        Query<Object?>? query = null;

        while (it.moveNext()) {
          MapEntry entry = it.current;
          query = ref!.where(entry.key, isEqualTo: entry.value);
        }

        if (query != null) {
          QuerySnapshot<Object?> col = await query.get();

          if (col.size > 0) {
            Iterator it = col.docs.iterator;

            BaseModel resultModel = this.objectModel;

            if (this.subObject != null) resultModel = this.subObject!;

            while (it.moveNext()) {
              BaseModel resultObj = resultModel;

              DocumentSnapshot<Object?> doc = it.current;

              resultObj.toObject(doc.id, doc.data());

              resultList.add(resultObj);
            }
          }
        }

        return resultList;
      } catch (e) {
        print("Error occurred while retrieving data : $e");
        return null;
      }
    } else {
      throw Exception("Firestore reference is null, please verify if you are using firestore or storage");
    }
  }

  Future<bool> save() async {
    if (ref != null) {
      BaseModel toSaveObject = this.subObject ?? this.objectModel;
      try {
        await ref!.doc(toSaveObject.id).update(toSaveObject.toMap());

        return true;
      } catch (e) {
        print("Error occurred while saving ${toSaveObject.runtimeType} : $e");
        return false;
      }
    } else {
      throw Exception("Firestore reference is null, please verify if you are using firestore or storage");
    }
  }

  // storage method
  Future<bool> uploadFile() async {
    if (storageRef != null) {
      try {
        Map<String, File> fileList = objectModel.getFileList();
        if (fileList.length > 0) {
          Iterator it = fileList.entries.iterator;

          while (it.moveNext()) {
            MapEntry map = it.current;
            String fileName = map.key;
            File file = map.value;

            await storageRef!.child("${objectModel.id}/$fileName").putFile(file);
          }

          return true;
        } else {
          throw Exception("File list is empty");
        }
      } catch (e) {
        print("Error occurred while uploading file : $e");
        return false;
      }
    } else {
      throw Exception("Storage reference is null, please verify if you are using firestore or storage");
    }
  }

  Future<Uint8List?> downloadFile(String fileName) async {
    if (storageRef != null) {
      try {
        return await storageRef!.child("${objectModel.id}/$fileName").getData();
      } catch (e) {
        print("Error occurred while downloading file : $e");
        return null;
      }
    } else {
      throw Exception("Storage reference is null, please verify if you are using firestore or storage");
    }
  }
}
