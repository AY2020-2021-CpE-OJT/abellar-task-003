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
  final phonebookController = TextEditingController();

  @override
  void dispose() {
    phonebookController.dispose();
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
                Text('Last Name:'),
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                )),
              ],
            ),Row(
              children: [
                Text('First Name:'),
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
