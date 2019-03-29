import 'package:sqflite/sqflite.dart';

// Defining the Strings that represent the columns of the database table
// Using "final" type because this value will not change

final String idCol = "idCol";
final String nameCol = "nameCol";
final String emailCol = "emailCol";
final String phoneCol = "phoneCol";
final String imgCol = "imgCol";

/* Here is a example of singleton pattern in Dart, this class don't have to be
*  a instance for initialize, their method are available of any local of code
* when the _instance method is called */

class ContactHelper {
  /* When ContactHelper is called the factory construct an instance, what's
  * the ContactHelper.internal method, that's allow use all other methods of
  * this class */

  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  // Database is a type of sqlite API of Dart, and one database inside a
  // variable called _db is created.

  Database _db;

/* Theses getters and setters are necessarily, not only for protect the
   variable, but also for implement a kind of test or validation to know if
   the database is already created, when this variable is instantiated, it's
    create a new Database */

  get db {

    // Now the method to know if the database isn't null

    if(_db != null){
      return _db; // If isn't null returns a _db registered on Database type
    }
  }
}

// Begin of model class tgito Contact

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  // Recovering the data from map database to a normal object
  // The name of method "fromMap" is created by user
  // So this is a simple function that's inside contact and receive a Map as parameter

  Contact.fromMap(Map map) {
    // Putting the columns variables inside class variables

    id = map[idCol];
    name = map[nameCol];
    email = map[emailCol];
    phone = map[phoneCol];
    img = map[imgCol];
  }

  // Putting the object values inside a map

  Map toMap() {
    Map<String, dynamic> map = {
      nameCol: name,
      emailCol: email,
      phoneCol: phone,
      imgCol: img,
    };

    // When the object is created, it's don't have an id
    // So the database have to attribute the id
    // If the object isn't null, the id variable is set to idCol

    if (id != null) {
      map[idCol] = id;
    }

    // In the end of all, this function returns a map

    return map;
  }

  // Overriding toString method to show better the information

  @override
  String toString() {
    return "Contact (id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}

// End of model class to Contact
