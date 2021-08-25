import 'package:meta/meta.dart';

class Contact {
  String name;
  String email;
  String phoneNumber;
  bool isFavorite;

  Contact(
      { required this.name,
      required this.email,
      required this.phoneNumber,
      this.isFavorite = false });
}
