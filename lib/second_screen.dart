import 'package:flutter/material.dart';

import 'contacts_db.dart';
import 'main.dart';
import 'edit_widget.dart';


class SecondScreen extends StatelessWidget {
  final List<ContactLocal> todo;

  SecondScreen({Key? key, required this.todo}) : super(key: key);

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
                  itemCount: todo.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          '${todo[index].firstName} ${todo[index].lastName}'),
                      subtitle: Text('${todo[index].phoneNumbers}'),
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
        EditContactWidget(),
      ]),
    );
  }
}