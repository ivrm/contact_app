import 'package:image_picker/image_picker.dart';

class Contact {
  // Database id (key)
  int? id;
  String name;
  String email;
  String phoneNumber;
  bool isFavorite;
  XFile? imageFile;

  Contact({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isFavorite = false,
    this.imageFile,
  });

  Map<String, dynamic> toMap() {
    // Map literals are created with curly braces {}
    return {
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "isFavorite": isFavorite ? 1 : 0,
      "imageFilePath": imageFile?.path,
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      isFavorite: map['isFavorite'] == 1 ? true : false,
      imageFile:
          map['imageFilePath'] != null ? XFile(map['imageFilePath']) : null,
    );
  }
}
