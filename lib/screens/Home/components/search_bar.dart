import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget searchBar(TextEditingController searchController) => Center(
      child: TextField(
          controller: searchController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              label: Text("Search A Book"),
              hintText: "Let us C")),
    );
