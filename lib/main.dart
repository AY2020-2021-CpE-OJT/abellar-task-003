import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

void main() => runApp(pbApp());

class Todo {
  final String last_name;
  final String first_name;
  final List<String> phone_numbers;

  Todo(this.last_name, this.first_name, this.phone_numbers);
}

class pbApp extends StatelessWidget {
  const pbApp({Key? key}) : super(key: key);

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

  int nPhoneNumber = 1;

  void saveContact() {
    List<String> pnums = <String>[];
    for(int i = 0; i < nPhoneNumber; i++) {
      pnums.add(pnumCtrlrs[i].text);
    }
    setState(() {
      names_todo.insert(
          0, Todo(lnameCtrlr.text, fnameCtrlr.text, pnums));
    });

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
                child: Icon(Icons.account_circle_rounded, size: 100.0,),
              ),
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(), labelText: 'First Name'),
                      controller: fnameCtrlr,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(), labelText: 'Last Name'),
                      controller: lnameCtrlr,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Flexible(
            fit: FlexFit.loose,
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ElevatedButton(
                      onPressed: saveContact,
                      child: Text('Submit'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: ElevatedButton(
                    onPressed: gotoNextScreen,
                    child: Text('Show'),
                  ),
                ),
              ],
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
        child: ListView.builder(
          itemCount: todo.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${todo[index].first_name} ${todo[index].last_name} ${todo[index].phone_numbers}'),
            );
          },
        ),
      ),
    );
  }
}
