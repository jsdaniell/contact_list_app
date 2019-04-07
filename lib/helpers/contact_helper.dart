import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Defining the Strings that represent the columns of the database table
// Using "final" type because this value will not change

final String contactTable = "contactTable";
final String idCol = "idCol";
final String nameCol = "nameCol";
final String emailCol = "emailCol";
final String phoneCol = "phoneCol";
final String imgCol = "imgCol";

/* Here is a example of singleton pattern in Dart, this class don't have to be
*  a instance for initialize, their method are available of any local of code
* when the _instance method is called, so this is a unique class of all code. */

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

  // This function don't return instantaneously so have to be a Future object.

  Future<Database> get db async {
    // Now the method to know if the database isn't null

    if (_db != null) {
      return _db; // If isn't null returns a _db registered on Database type
    } else {
      _db = await initDb(); // If null (not created), initiate a new database

      /* The initDb() is a asynchronous function, so have to be a Future object
      * to return */

      return _db;
    }
  }

  // Function to initialize the database

  /* The initDb() is a asynchronous function, so have to be a Future object
  * to return */

  Future<Database> initDb() async {
    // Capturing the path where the database will be stored

    /* The getDatabasesPath have a delay for complete and return the path, so
    * this function have a await word, showing that's variable have to await
    * the getDatabasesPath finish.
    *
    * For use await word, the function have to be async.*/

    final databasesPath = await getDatabasesPath();

    /* join method converts each element to a String and concatenates the strings.
    * Iterates through elements of this iterable, converts each one to a String
    * by calling Object.toString, and then concatenates the strings, with the
    * separator string interleaved between the elements.*/

    final path = join("databasesPath", "contacts.db");

    // Now the path for database is concluded.
    // Opening the database

    /* The openDatabase method, has a path and version as parameter, although,
    * the onCreate has a Database and a version, this requires isn't
    * instantaneous so have to be an async function */

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      // The SQL command to initiate

      await db.execute(
          "CREATE TABLE $contactTable($idCol INTEGER PRIMARY KEY, $nameCol TEXT, $emailCol TEXT, $phoneCol TEXT, $imgCol TEXT)");
    });
  }

  // Saving contact on database

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;

    // Here the method toMap catch the attributes of table and pass toMap

    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  // Obtaining contact for database

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(contactTable,
        columns: [idCol, nameCol, emailCol, phoneCol, imgCol],
        where: "$idCol = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Deleting contact inside database

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact
        .delete(contactTable, where: "$idCol = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
    return await dbContact.update(contactTable, contact.toMap(),
        where: "$idCol = ?", whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = List();
    for (Map m in listMap) {
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int> getNumber() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(
        await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  // Closing database

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }
}

// Begin of model class Contact

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
