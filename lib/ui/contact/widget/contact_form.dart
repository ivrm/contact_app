import 'dart:io';

import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactForm extends StatefulWidget {
  final Contact? contact;

  ContactForm({Key? key, this.contact}) : super(key: key);

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  XFile? _contactImageFile;
  bool get isEditMode => widget.contact?.id != null;
  bool get hasSelectedCustomImage => _contactImageFile != null;

  @override
  void initState() {
    super.initState();
    _contactImageFile = widget.contact?.imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10),
              _buildContactPicture(),
              SizedBox(height: 10),
              TextFormField(
                initialValue: widget.contact?.name,
                validator: _validateName,
                onSaved: (value) => _name = value ?? '',
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: widget.contact?.email,
                validator: _validateEmail,
                onSaved: (value) => _email = value ?? '',
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: widget.contact?.phoneNumber,
                validator: _validatePhoneNumber,
                onSaved: (value) => _phoneNumber = value ?? '',
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: _onSaveContactButtonPressed,
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('SAVE CONTACT'),
                    Icon(Icons.person, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildContactPicture() {
    final halfScreenWidth = MediaQuery.of(context).size.width / 2;

    return Hero(
      tag: widget.contact.hashCode,
      child: GestureDetector(
        onTap: _onContactPictureTapped,
        child: CircleAvatar(
          radius: halfScreenWidth / 2,
          child: _buildCircleAvatarContent(halfScreenWidth),
        ),
      ),
    );
  }

  Future<void> _onContactPictureTapped() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _contactImageFile = image;
    });
  }

  Widget _buildCircleAvatarContent(double halfScreenWidth) {
    var maxSize = halfScreenWidth / 2;

    if (isEditMode || hasSelectedCustomImage) {
      return _buildEditModeCircleAvatarContent(maxSize);
    } else {
      return Icon(Icons.person, size: maxSize);
    }
  }

  Widget _buildEditModeCircleAvatarContent(double maxSize) {
    if (_contactImageFile == null) {
      return Text(
        widget.contact?.name[0] ?? '',
        style: TextStyle(fontSize: maxSize),
      );
    } else {
      return ClipOval(
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.file(
            File(_contactImageFile!.path),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  String? _validateName(String? value) {
    if (null == value || value.isEmpty) {
      return 'Enter name';
    }

    return null;
  }

  void _onSaveContactButtonPressed() {
    var form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();

      final contact = Contact(
        name: _name,
        email: _email,
        phoneNumber: _phoneNumber,
        isFavorite: widget.contact?.isFavorite ?? false,
        imageFile: _contactImageFile,
      );

      var model = ScopedModel.of<ContactsModel>(context);
      if (isEditMode) {
        contact.id = widget.contact?.id;
        model.updateContact(contact);
      } else {
        model.addContact(contact);
      }

      Navigator.of(context).pop();
    }
  }

  String? _validateEmail(String? value) {
    final _regex = RegExp(
        r"^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");

    if (null == value || value.isEmpty) {
      return 'Enter an Email';
    } else if (!_regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? _validatePhoneNumber(String? value) {
    final _regex = RegExp(
        r"\+?(9[976]\d|8[987530]\d|6[987]\d|5[90]\d|42\d|3[875]\d|2[98654321]\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\d{1,14}$");

    if (null == value || value.isEmpty) {
      return 'Enter a phone number';
    } else if (!_regex.hasMatch(value)) {
      return 'Enter a valid phone number';
    }

    return null;
  }
}
