import 'package:contacts_app/data/contact.dart';
import 'package:flutter/material.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({
    Key? key,
    required this.contact,
    required this.onFavoriteClick,
  }) : super(key: key);

  final Contact contact;
  final void Function() onFavoriteClick;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contact.name),
      subtitle: Text(contact.email),
      trailing: IconButton(
        icon: Icon(contact.isFavorite ? Icons.star : Icons.star_border),
        color: contact.isFavorite ? Colors.amber : Colors.grey,
        onPressed: onFavoriteClick,
      ),
    );
  }
}
