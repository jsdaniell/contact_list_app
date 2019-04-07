import 'package:contact_list/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  /* In a normal class, declaring two objects of this function, will be created
  * two databases, two total different objects, but this is a singleton class
  * so the two objects represents the same database same class. */

  // ContactHelper helper = ContactHelper(); → The same object above.

  ContactHelper helper = ContactHelper();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
