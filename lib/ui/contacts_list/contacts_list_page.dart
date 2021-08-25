import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/widget/contact_tile.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';

class ContactsListPage extends StatefulWidget {
  @override
  _ContactsListPageState createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  late List<Contact> _contacts;

  @override
  void initState() {
    super.initState();

    _contacts = List.generate(50, (index) {
      var faker = new Faker();
      return Contact(
          name: faker.person.firstName() + " " + faker.person.lastName(),
          email: faker.internet.freeEmail(),
          phoneNumber: faker.randomGenerator.integer(10000000).toString());
    });
  }

  // runs on every state changes
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ListView.builder(
          itemCount: _contacts.length,
          itemBuilder: (context, index) {
            var contact = _contacts[index];
            return ContactTile(
              contact: contact,
              onFavoriteClick: () {
                setState(() {
                  contact.isFavorite = !contact.isFavorite;
                  _contacts.sort((a, b) {
                    if (a.isFavorite) {
                      return -1;
                    } else if (b.isFavorite) {
                      return 1;
                    } else {
                      return 0;
                    }
                  });
                });
              },
            );
          }),
    );
  }
}
