import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class PhonebookTodo {
  final List<String> lastName;
  final List<String> firstName;

  //final List<List> phoneNumbers;

  PhonebookTodo(this.lastName, this.firstName);
}

void main() => runApp(PhoneBookApp());

class ContactStorage {
  Future<String> get _localPath async {
    final dir = await getApplicationDocumentsDirectory();

    return dir.path;
  }

  Future<File> get _contactFile async {
    final path = await _localPath;
    return File('$path/contact.txt');
  }

  Future<File> writeContact(PhonebookTodo contact) async {
    final file = await _contactFile;

    // Write the file
    return file.writeAsString('$contact');
  }

  Future<String> readContact() async {
    try {
      final file = await _contactFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return 'error';
    }
  }
}

class PhoneBookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Phonebook',
      home: InputForm(
        storage: ContactStorage(),
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  final ContactStorage storage;

  InputForm({Key? key, required this.storage}) : super(key: key);

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final lastNameCtrlr = TextEditingController();
  final firstNameCtrlr = TextEditingController();
  final List conNumsCtrlr = [];
  final _formKey = GlobalKey<FormState>();

  int nOfPhoneNumber = 1;
  String sample = 'to changed';

  final List<String> fnames = <String>[];
  final List<String> lnames = <String>[];

  void addPhoneNumber() {
    setState(() {
      nOfPhoneNumber++;
    });
  }

  void minusPhoneNumber() {
    setState(() {
      nOfPhoneNumber--;
    });
  }

  @override
  void dispose() {
    lastNameCtrlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.account_circle_rounded, size: 100.0),
                ),
                Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Last Name',
                        ),
                        controller: lastNameCtrlr,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'First Name',
                        ),
                        controller: firstNameCtrlr,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2.5),
                    child: OutlinedButton(
                      onPressed: addPhoneNumber,
                      child: Text('+', style: TextStyle(fontSize: 20.0)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.5, right: 5),
                    child: OutlinedButton(
                      onPressed: addPhoneNumber,
                      child: Text('-', style: TextStyle(fontSize: 20.0)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Contacts'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowContactScreen(
                              todo: PhonebookTodo(lnames, fnames),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.5),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.storage.writeContact(PhonebookTodo(lnames, fnames));
                      },
                      child: Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: nOfPhoneNumber,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Number'),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                              width: 25.0, height: 25.0),
                          child: ElevatedButton(
                            onPressed: minusPhoneNumber,
                            child: Text('x'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(1.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          lnames.insert(0, lastNameCtrlr.text);
          fnames.insert(0, firstNameCtrlr.text);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowContactScreen(
                todo: PhonebookTodo(lnames, fnames),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ShowContactScreen extends StatelessWidget {
  final PhonebookTodo todo;

  const ShowContactScreen({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${todo.firstName[index]} ${todo.lastName[index]}'),
                  );
                },
                itemCount: todo.firstName.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
