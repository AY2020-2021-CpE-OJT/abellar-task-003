import 'package:flutter/material.dart';

import 'contacts_db.dart';
import 'main.dart';
import 'edit_widget.dart';


class SecondScreen extends StatefulWidget {
  final List<ContactLocal> todo;

  SecondScreen({Key? key, required this.todo,}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();

  static _SecondScreenState? of(BuildContext context) => context.findAncestorStateOfType<_SecondScreenState>();
}

class _SecondScreenState extends State<SecondScreen> {
  bool _visibilityOfEditWidget = false;
  FutureBuilder<Contacts> _toBeEdit = FutureBuilder(builder: (context, contact) {return const Text('Loading...');});

  set editVisibilityOfWidget(bool val) => setState(() {
    _visibilityOfEditWidget = val;
  });
  set editToBeEdit(FutureBuilder<Contacts> val) => setState(() {
    _toBeEdit = val;
  });

  final editLastName = TextEditingController();
  final editFirstName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text('Local Variable',
                    style: TextStyle(color: Colors.grey)),
              ),
              const Divider(
                thickness: 1.0,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 75),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.todo.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          '${widget.todo[index].firstName} ${widget.todo[index].lastName}'),
                      subtitle: Text('${widget.todo[index].phoneNumbers}'),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child:
                Text('From Database', style: TextStyle(color: Colors.grey)),
              ),
              const Divider(
                thickness: 1.0,
              ),
              const Expanded(child: ContactsFromDatabase()),
            ],
          ),
        ),
        EditContactWidget(visibility: _visibilityOfEditWidget, toBeEdit: _toBeEdit,),
      ]),
    );
  }
}