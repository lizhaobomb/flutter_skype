import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_skype/provider/image_upload_provider.dart';
import 'package:flutter_skype/resources/chat_methods.dart';

class StorageMethods {

  StorageReference _storageReference;

  static final ChatMethods _chatMethods = ChatMethods();

  Future<String> uploadImageToStorage(File image) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');

      StorageUploadTask _storageUploadTask = _storageReference.putFile(image);
      var url =
          await (await _storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  

  void uploadImage(File image, String receiverId, String senderId,
      ImageUploadProvider imageUploadProvider) async {
    imageUploadProvider.setToLoading();
    String url = await uploadImageToStorage(image);
    imageUploadProvider.setToIdle();
    _chatMethods.setImageMsg(url, receiverId, senderId);
  }
}