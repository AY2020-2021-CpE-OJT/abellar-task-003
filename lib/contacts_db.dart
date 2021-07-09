import 'dart:async';

import 'package:abellar_task_003/edit_widget.dart';
import 'package:abellar_task_003/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class ContactsFromDatabase extends StatefulWidget {
  const ContactsFromDatabase({Key? key}) : super(key: key);

  @override
  _ContactsFromDatabaseState createState() => _ContactsFromDatabaseState();
}

class _ContactsFromDatabaseState extends State<ContactsFromDatabase> {
  List<Future<Contacts>> futureContacts = <Future<Contacts>>[];
  late int futureNumOfContacts = 0;

  @override
  void initState() {
    super.initState();
    fetchNumOfContacts().then((value) {
      setState(() {
        futureNumOfContacts = int.parse(value);
        for (int i = 0; i < futureNumOfContacts; i++) {
          futureContacts.insert(i, fetchContacts(i));
        }
      });
    });
  }

  fetchNumOfContacts() async {
    final req = await http.get(Uri.parse('$host/contacts/total'));
    return req.body;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: futureContacts.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Expanded(
                child: ListTile(
                  title: FutureBuilder<Contacts>(
                    builder: (context, contact) {
                      if (contact.hasData) {
                        return Text(
                            '${contact.data!.firstName.toString()} ${contact.data!.lastName.toString()}');
                      } else if (contact.hasError)
                        return Text("${contact.error}");
                      return const Center(child: CircularProgressIndicator());
                    },
                    future: futureContacts[index],
                  ),
                  subtitle: FutureBuilder<Contacts>(
                    builder: (context, contact) {
                      if (contact.hasData) {
                        return Text(contact.data!.phoneNumbers
                            .toString()
                            .replaceAll("[", "")
                            .replaceAll("]", ""));
                      } else if (contact.hasError)
                        return Text("${contact.error}");
                      return const Center(child: Text('Loading Data'));
                    },
                    future: futureContacts[index],
                  ),
                  onLongPress: () {
                    SecondScreen.of(context)!.editVisibilityOfWidget = true;
                    SecondScreen.of(context)!.editToBeEdit = FutureBuilder(
                      builder: (context, contact) {
                        return TextFormField(
                          decoration: InputDecoration(
                              labelText: contact.data!.firstName.toString()),
                        );
                      },
                      future: futureContacts[index],
                    );
                  },
                ),
              ),
              FutureBuilder<Contacts>(
                builder: (context, contact) {
                  return OutlinedButton(
                    onPressed: () {
                      deleteContact(contact.data!.id.toString());
                      fetchNumOfContacts().then((value) {
                        setState(() {
                          futureContacts.removeAt(index);
                        });
                        futureNumOfContacts--;
                      });
                    },
                    child: const Icon(
                      Icons.delete,
                      size: 15.0,
                    ),
                    style:
                        OutlinedButton.styleFrom(shape: const CircleBorder()),
                  );
                },
                future: futureContacts[index],
              )
            ],
          );
        });
  }
}
