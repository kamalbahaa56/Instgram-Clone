import 'package:firebase_storage/firebase_storage.dart';

GitURLImage({required imgPath, required imgName, required ImageFile}) async {
  // Upload image to firebase storage
  final storageRef = FirebaseStorage.instance.ref('$ImageFile/${imgName}');
  await storageRef.putFile(imgPath!);

// Get img url
  String url = await storageRef.getDownloadURL();
  return url;
}
