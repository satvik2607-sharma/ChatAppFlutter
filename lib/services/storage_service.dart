import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;

class StorageService {
  final GetIt getIt = GetIt.instance;
  StorageService() {}

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadImageToChat(
      {required File file, required String chatId}) async {
    Reference fileRef = _firebaseStorage
        .ref('chats/$chatId')
        .child('${DateTime.now().toIso8601String()}${p.extension(file.path)}');
    UploadTask task = fileRef.putFile(file);
    return task.then((p) {
      if (p.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
    });
  }
}
