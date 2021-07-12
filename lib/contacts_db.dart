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
  int pnAdd = 0;

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

  final lNameEditCtrl = TextEditingController();
  final fNameEditCtrl = TextEditingController();

  FutureBuilder<Contacts> buildEditWidget(int index, bool edit) {
    List<TextEditingController> pNumbersCtrl = [];
    return FutureBuilder(
      builder: (context, contact) {
        if (contact.hasData) {
          for (int i = 0; i < contact.data!.phoneNumbers.length + pnAdd; i++) {
            pNumbersCtrl.add(TextEditingController());
          }
          return ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height - 350),
            child: Stack(children: [
              Visibility(
                visible: !edit,
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Text(
                            '${contact.data!.firstName.toString()} ${contact.data!.lastName.toString()}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            child: const Icon(
                              Icons.call,
                              size: 10,
                            ),
                            style: OutlinedButton.styleFrom(
                                shape: const CircleBorder()),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              deleteContact(contact.data!.id.toString());
                              fetchNumOfContacts().then((value) {
                                setState(() {
                                  futureContacts.removeAt(index);
                                });
                                futureNumOfContacts--;
                                setState(() {
                                  SecondScreen.of(context)!
                                      .editVisibilityOfWidget = false;
                                });
                              });
                            },
                            child: const Icon(
                              Icons.delete,
                              size: 10,
                            ),
                            style: OutlinedButton.styleFrom(
                                shape: const CircleBorder()),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              SecondScreen.of(context)!.editToBeEdit =
                                  buildEditWidget(index, true);
                            },
                            child: const Icon(
                              Icons.edit,
                              size: 10,
                            ),
                            style: OutlinedButton.styleFrom(
                                shape: const CircleBorder()),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ListView.separated(
                        itemCount: contact.data!.phoneNumbers.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 12, right: 12, bottom: 8),
                            child: Text(
                                contact.data!.phoneNumbers[index].toString()),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 1,
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: const Text('Done'),
                            onPressed: () {
                              //Update
                              setState(() {
                                SecondScreen.of(context)!
                                    .editVisibilityOfWidget = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: edit,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            child: const Icon(
                              Icons.call,
                              size: 10,
                            ),
                            style: OutlinedButton.styleFrom(
                                shape: const CircleBorder()),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              deleteContact(contact.data!.id.toString());
                              fetchNumOfContacts().then((value) {
                                setState(() {
                                  futureContacts.removeAt(index);
                                });
                                futureNumOfContacts--;
                                setState(() {
                                  SecondScreen.of(context)!
                                      .editVisibilityOfWidget = false;
                                });
                              });
                            },
                            child: const Icon(
                              Icons.delete,
                              size: 10,
                            ),
                            style: OutlinedButton.styleFrom(
                                shape: const CircleBorder()),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            child: const Icon(
                              Icons.edit,
                              size: 10,
                            ),
                            style: OutlinedButton.styleFrom(
                                shape: const CircleBorder()),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: TextFormField(
                                controller: fNameEditCtrl,
                                decoration: InputDecoration(
                                    hintText:
                                        contact.data!.firstName.toString()),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: lNameEditCtrl,
                              decoration: InputDecoration(
                                hintText: contact.data!.lastName.toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: ListView.builder(
                          itemCount: contact.data!.phoneNumbers.length + pnAdd,
                          itemBuilder: (context, index) {
                            return TextFormField(
                              controller: pNumbersCtrl[index],
                              decoration: InputDecoration(
                                  labelText: 'Phone Number #${index + 1}'),
                            );
                          }),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              pnAdd++;
                              SecondScreen.of(context)!.editToBeEdit =
                                  buildEditWidget(index, true);
                            },
                            child: const Icon(Icons.add),
                            style: OutlinedButton.styleFrom(
                                shape: const CircleBorder()),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              if (contact.data!.phoneNumbers.length + pnAdd >
                                  0) {
                                pnAdd--;
                              }
                              SecondScreen.of(context)!.editToBeEdit =
                                  buildEditWidget(index, true);
                            },
                            child: const Icon(Icons.remove),
                            style: OutlinedButton.styleFrom(
                                shape: const CircleBorder()),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              child: const Text('Confirm'),
                              onPressed: () {
                                //Update
                                List<String> pNumbers = [];
                                for (int i = 0; i < pNumbersCtrl.length; i++) {
                                  pNumbers.add(pNumbersCtrl[i].text);
                                }
                                updateContact(
                                    lNameEditCtrl.text,
                                    fNameEditCtrl.text,
                                    pNumbers,
                                    contact.data!.id);
                                setState(() {
                                  SecondScreen.of(context)!
                                      .editVisibilityOfWidget = false;
                                });
                                futureContacts.clear();
                                fetchNumOfContacts().then((value) {
                                  setState(() {
                                    futureNumOfContacts = int.parse(value);
                                    for (int i = 0;
                                        i < futureNumOfContacts;
                                        i++) {
                                      futureContacts.insert(
                                          i, fetchContacts(i));
                                    }
                                  });
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          );
        }
        return const Text('');
      },
      future: futureContacts[index],
    );
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
                      } else if (contact.hasError) {
                        return Text("${contact.error}");
                      }
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
                      } else if (contact.hasError) {
                        return Text("${contact.error}");
                      }
                      return const Center(child: Text('Loading Data'));
                    },
                    future: futureContacts[index],
                  ),
                  onLongPress: () {
                    SecondScreen.of(context)!.editVisibilityOfWidget = true;
                    SecondScreen.of(context)!.editToBeEdit =
                        buildEditWidget(index, false);
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
