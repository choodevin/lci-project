import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

import '../Model/BaseModel.dart';

class FirebaseService {
  CollectionReference? ref;
  Reference? storageRef;

  BaseModel objectModel;

  FirebaseService.firestore(this.objectModel) {
    this.ref = FirebaseFirestore.instance.collection(objectModel.tableName!);
  }

  FirebaseService.storage(this.objectModel) {
    this.storageRef = FirebaseStorage.instance.ref("/${objectModel.tableName}");
  }

  // firestore method
  Future<dynamic> getDocumentById(String id) async {
    if (ref != null) {
      DocumentSnapshot<Object?> doc = await ref!.doc(id).get();
      var resultObj = this.objectModel;

      if (doc.exists) {
        resultObj.toObject(doc.id, doc.data());
      } else {
        return null;
      }

      return resultObj;
    } else {
      throw Exception("Collection reference is null, please verify if you are using firestore or storage");
    }
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
        print("Error occurred while creating document : $e");
      }
    } else {
      throw Exception("Collection reference is null, please verify if you are using firestore or storage");
    }

    return null;
  }

  // firestore method
  Future<bool> createDocument() async {
    if (ref != null) {
      try {
        objectModel.creationTime = Timestamp.now();
        objectModel.updateTime = Timestamp.now();

        Map<String, dynamic> doc = objectModel.toMap();

        await ref!.add(doc).then((doc) => objectModel.id = doc.id);

        return true;
      } catch (e) {
        print("Error occurred while creating document : $e");
        return false;
      }
    } else {
      throw Exception("Collection reference is null, please verify if you are using firestore or storage");
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

            print(storageRef!.child("${objectModel.id}/$fileName${Path.extension(file.path)}").fullPath);
            await storageRef!.child("${objectModel.id}/$fileName${Path.extension(file.path)}").putFile(file);
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
}
