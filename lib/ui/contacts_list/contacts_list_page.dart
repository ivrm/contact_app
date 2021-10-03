import 'package:contacts_app/ui/contact/contact_create_page.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:contacts_app/ui/widget/contact_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactsListPage extends StatefulWidget {
  @override
  _ContactsListPageState createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ScopedModelDescendant<ContactsModel>(
        builder: (BuildContext context, Widget? child, ContactsModel model) {
          if (model.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                itemCount: model.contacts.length,
                itemBuilder: (context, index) {
                  return ContactTile(
                    contact: model.contacts[index],
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => ContactCreatePage()));
        },
      ),
    );
  }
}
