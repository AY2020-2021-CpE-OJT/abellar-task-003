import 'package:flutter/material.dart';

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

  void addPhoneNumber() {
    setState(() {
      nOfPhoneNumber++;
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
            Container(
              height: 300.0,
              child: ListView.builder(
                itemCount: nOfPhoneNumber,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: TextFormField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(), labelText: 'Number'),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addPhoneNumber,
      ),
    );
  }
}
