import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/data/db/contact_dao.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactsModel extends Model {
  final _contactDao = ContactDao();
  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future loadContacts() async {
    _isLoading = true;
    notifyListeners();
    _contacts = await _contactDao.getAllInSortedOrder();
    _isLoading = false;
    notifyListeners();
  }

  Future addContact(Contact contact) async {
    await _contactDao.insert(contact);
    await loadContacts();
    notifyListeners();
  }

  Future updateContact(Contact contact) async {
    await _contactDao.update(contact);
    await loadContacts();
    notifyListeners();
  }

  Future deleteContact(Contact contact) async {
    await _contactDao.delete(contact);
    await loadContacts();
    notifyListeners();
  }

  Future changeFavoriteStatus(Contact contact) async {
    contact.isFavorite = !contact.isFavorite;
    await _contactDao.update(contact);
    await loadContacts();
    notifyListeners();
  }
}
