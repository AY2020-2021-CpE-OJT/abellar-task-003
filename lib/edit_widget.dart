import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'second_screen.dart';
import 'main.dart';
import 'contacts_db.dart';

updateContact(String lName, String fName, List<dynamic> pNumbers,
    String id) async {
  await http.put(Uri.parse('$host/contacts/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<dynamic, dynamic>{
        'last_name': lName,
        'first_name': fName,
        'phone_numbers': pNumbers
      }));
}


class EditContactWidget extends StatefulWidget {
  bool visibility;
  final FutureBuilder<Contacts> toBeEdit;

  EditContactWidget(
      {Key? key, required this.visibility, required this.toBeEdit,})
      : super(key: key);

  @override
  _EditContactWidgetState createState() => _EditContactWidgetState();

  static _EditContactWidgetState? of(BuildContext context) => context.findAncestorStateOfType<_EditContactWidgetState>();
}

class _EditContactWidgetState extends State<EditContactWidget> {

  void reset() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visibility,
      child: Stack(children: [
        InkWell(
          onTap: () {
            setState(() {
              widget.visibility = false;
            });
          },
          child: Container(
            color: Colors.black.withOpacity(0.75),
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.only(top: 75, left: 10, right: 10, bottom: 75),
          child: Center(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.account_circle_rounded,
                      size: 50,
                    ),
                    const Text(
                      'Edit Contacts',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Flexible(child: widget.toBeEdit),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}