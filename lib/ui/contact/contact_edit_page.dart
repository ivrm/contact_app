import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/contact/widget/contact_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactEditPage extends StatelessWidget {
  final Contact contact;

  ContactEditPage({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
      ),
      body: ContactForm(key: key, contact: this.contact),
    );
  }
}
