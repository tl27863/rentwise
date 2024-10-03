import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class UploadMethods{
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(String childName, String id, Uint8List file) async {
    Reference ref = _storage.ref().child(childName).child(id);

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downUrl = await snap.ref.getDownloadURL();
    return downUrl;
  }
}