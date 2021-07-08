import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'second_screen.dart';
import 'main.dart';
import 'contacts_db.dart';

class EditContactWidget extends StatefulWidget {
  bool visibility;

  EditContactWidget({Key? key, required this.visibility}) : super(key: key);

  @override
  EditContactWidgetState createState() => EditContactWidgetState();
}

class EditContactWidgetState extends State<EditContactWidget> {

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
          padding: const EdgeInsets.only(top: 75, left: 10, right: 10, bottom: 75),
          child: Center(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                    TextFormField(),
                    TextFormField(),
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
