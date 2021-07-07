import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const String host = 'http://192.168.254.101';

void main() => runApp(const PbApp());

class Todo {
  final String last_name;
  final String first_name;
  final List<String> phone_numbers;

  Todo(this.last_name, this.first_name, this.phone_numbers);
}

class PbApp extends StatelessWidget {
  const PbApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phonebook App',
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add Contacts'),
      ),
      body: InputContactForm(),
    );
  }
}

class InputContactForm extends StatefulWidget {
  const InputContactForm({Key? key}) : super(key: key);

  @override
  _InputContactFormState createState() => _InputContactFormState();
}

class _InputContactFormState extends State<InputContactForm> {
  List<Todo> names_todo = <Todo>[];
  Future<Contacts>? _futureContacts;

  int nPhoneNumber = 1;

  void saveContact() {
    List<String> pnums = <String>[];
    for (int i = 0; i < nPhoneNumber; i++) {
      pnums.add(pnumCtrlrs[i].text);
    }
    setState(() {
      names_todo.insert(0, Todo(lnameCtrlr.text, fnameCtrlr.text, pnums));
      _futureContacts = createContacts(lnameCtrlr.text, fnameCtrlr.text, pnums);
    });

    final snackBar = SnackBar(
      content: Text('Successfully Submitted Contacts'),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void gotoNextScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SecondScreeen(todo: names_todo)));
  }

  void addPhoneNumber() {
    setState(() {
      nPhoneNumber++;
      pnumCtrlrs.insert(0, TextEditingController());
    });
  }

  void subPhoneNumber() {
    setState(() {
      if (nPhoneNumber != 0) {
        nPhoneNumber--;
        pnumCtrlrs.removeAt(0);
      }
    });
  }

  final lnameCtrlr = TextEditingController();
  final fnameCtrlr = TextEditingController();

  //final pnumCtrlr = TextEditingController();
  List<TextEditingController> pnumCtrlrs = <TextEditingController>[
    TextEditingController()
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.account_circle_rounded,
                  size: 100.0,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'First Name'),
                      controller: fnameCtrlr,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Last Name'),
                      controller: lnameCtrlr,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Flexible(
            flex: 0,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 0.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Phone Number #${i + 1}'),
                      controller: pnumCtrlrs[i],
                      keyboardType: TextInputType.number,
                    ),
                  );
                },
                itemCount: nPhoneNumber,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(onPressed: addPhoneNumber, child: Icon(Icons.add)),
              OutlinedButton(
                  onPressed: subPhoneNumber,
                  child: Text(
                    '-',
                    style: TextStyle(fontSize: 25),
                  )),
            ],
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: ElevatedButton(
                        onPressed: saveContact,
                        child: Text('Submit'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: ElevatedButton(
                        onPressed: gotoNextScreen,
                        style: ElevatedButton.styleFrom(primary: Colors.grey),
                        child: Text('View'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondScreeen extends StatelessWidget {
  final List<Todo> todo;

  const SecondScreeen({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Local Variable',
                  style: TextStyle(
                      color: Colors.grey)),
                ),
            const Divider(
              thickness: 1.0,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 100),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: todo.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${todo[index].first_name} ${todo[index].last_name}'),
                    subtitle: Text('${todo[index].phone_numbers}'),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                  'From Database',
                  style: TextStyle(
                      color: Colors.grey)),
            ),
            const Divider(
              thickness: 1.0,
            ),
            const Expanded(child: ContactsFromDatabase()),
          ],
        ),
      ),
    );
  }
}

Future<Contacts> createContacts(
    String lastName, String firstName, List<dynamic> phoneNumbers) async {
  final res = await http.post(Uri.parse('$host:5000/contacts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'last_name': lastName,
        'first_name': firstName,
        'phone_numbers': phoneNumbers
      }));

  if (res.statusCode == 201) {
    return Contacts.fromJson(jsonDecode(res.body));
  } else {
    throw Exception('Failed to create contact');
  }
}

Future<Contacts> fetchContacts(int index) async {
  final res = await http.get(Uri.parse('$host:5000/contacts'));

  if (res.statusCode == 200) {
    return Contacts.fromJson(jsonDecode(res.body)[index]);
  } else
    throw Exception('Failed to load contacts');
}

class Contacts {
  final dynamic id;
  final String last_name;
  final String first_name;
  final List<dynamic> phone_numbers;

  Contacts({
    required this.id,
    required this.last_name,
    required this.first_name,
    required this.phone_numbers,
  });

  factory Contacts.fromJson(Map<String, dynamic> json) {
    return Contacts(
      id: json['_id'],
      last_name: json['last_name'],
      first_name: json['first_name'],
      phone_numbers: json['phone_numbers'],
    );
  }
}

class ContactsFromDatabase extends StatefulWidget {
  const ContactsFromDatabase({Key? key}) : super(key: key);

  @override
  _ContactsFromDatabaseState createState() => _ContactsFromDatabaseState();
}

class _ContactsFromDatabaseState extends State<ContactsFromDatabase> {
  List<Future<Contacts>> futureContacts = <Future<Contacts>>[];
  late int futureNumOfContacts = 0;
  late var samstring = '';

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

  var infos;

  fetchNumOfContacts() async {
    final req = await http.get(Uri.parse('$host:5000/contacts/total'));
    infos = req.body;
    //print(infos);
    return infos;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: futureNumOfContacts,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Expanded(
                child: ListTile(
                  title: FutureBuilder<Contacts>(
                    builder: (context, contact) {
                      if (contact.hasData)
                        return Text(
                            '${contact.data!.first_name.toString()} ${contact.data!.last_name.toString()}');
                      else if (contact.hasError)
                        return Text("${contact.error}");
                      return Center(child: CircularProgressIndicator());
                    },
                    future: futureContacts[index],
                  ),
                  subtitle: FutureBuilder<Contacts>(
                    builder: (context, snapshot) {
                      //initState();
                      //print(infos);
                      if (snapshot.hasData)
                        return Text(snapshot.data!.phone_numbers.toString());
                      else if (snapshot.hasError)
                        return Text("${snapshot.error}");
                      return Center(child: CircularProgressIndicator());
                    },
                    future: futureContacts[index],
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Icon(Icons.delete),
                style: OutlinedButton.styleFrom(shape: CircleBorder()),
              )
            ],
          );
        });
  }
}
