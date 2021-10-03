import 'dart:io';

import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/contact/contact_edit_page.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class ContactTile extends StatelessWidget {
  final Contact contact;
  const ContactTile({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<ContactsModel>(context);

    return Slidable(
      actionPane: SlidableBehindActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            model.deleteContact(contact);
          },
        )
      ],
      actions: <Widget>[
        IconSlideAction(
          caption: 'Call',
          color: Colors.green,
          icon: Icons.phone,
          onTap: () => _callPhoneNumber(context, contact.phoneNumber),
        ),
        IconSlideAction(
          caption: 'Email',
          color: Colors.blue,
          icon: Icons.mail,
          onTap: () => _writeEmail(context, contact.email),
        ),
      ],
      child: _buildContent(context, contact, model),
    );
  }

  Future _callPhoneNumber(BuildContext context, String number) async {
    final url = "tel:$number";
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    } else {
      final SnackBar snackbar = SnackBar(content: Text('Cannot make call'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future _writeEmail(BuildContext context, String email) async {
    final url = "mailto:$email";
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    } else {
      final SnackBar snackbar = SnackBar(
        content: Text(
          'Cannot write an email',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  // Container used for styling UI
  Container _buildContent(
      BuildContext context, Contact contact, ContactsModel model) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: ListTile(
        title: Text(contact.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(contact.email),
            Text(contact.phoneNumber),
          ],
        ),
        leading: _buildCircleAvatar(contact),
        trailing: IconButton(
          icon: Icon(contact.isFavorite ? Icons.star : Icons.star_border),
          color: contact.isFavorite ? Colors.amber : Colors.grey,
          onPressed: () {
            model.changeFavoriteStatus(contact);
          },
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ContactEditPage(
                contact: contact,
              ),
            ),
          );
        },
      ),
    );
  }

  Hero _buildCircleAvatar(Contact contact) {
    // Hero widget facilitates a hero animation between routes (pages) in a simple way.
    // It's important that the tag is the SAME and UNIQUE in both routes
    return Hero(
      tag: contact.hashCode,
      child: CircleAvatar(
        child: _buildCircleAvatarContent(contact),
      ),
    );
  }

  Widget _buildCircleAvatarContent(Contact contact) {
    if (contact.imageFile == null) {
      // Display the first letter from contact's name
      return Text(
        contact.name[0],
      );
    } else {
      return ClipOval(
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.file(
            File(contact.imageFile!.path),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
