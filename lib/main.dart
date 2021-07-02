import 'package:flutter/material.dart';

class PhonebookTodo {
  final List<String> lastName;
  final List<String> firstName;
  final List<int> phoneNumbers = [09954564469, 09945489033];

  PhonebookTodo(this.lastName, this.firstName);
}

void main() => runApp(PhoneBookApp());

class PhoneBookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Phonebook',
      home: InputForm(),
    );
  }
}

class InputForm extends StatefulWidget {
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final lastNameCtrlr = TextEditingController();
  final firstNameCtrlr = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int nOfPhoneNumber = 1;

  final List<String> names = <String>['Levi', 'eyy'];

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
                        )),
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
            OutlinedButton(
              onPressed: addPhoneNumber,
              child: Text('+', style: TextStyle(fontSize: 20.0)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          names.insert(0, 'Dummy');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowContactScreen(
                todo: PhonebookTodo(names, names),
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
        child: Text('${todo.lastName}'),
      ),
    );
  }
}
