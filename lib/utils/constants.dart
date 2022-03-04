// ignore_for_file: unnecessary_string_escapes

import 'package:flutter/material.dart';

void showSnackbar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

// Routes Constants
const welcomeRoute = "\welcome";
const loginRoute = "\login";
const signUpRoute = "\signup";
const bottomNavPanelRoute = "\bottom_nav_panel";
const homeRoute = "\home";
const notificationRoute = "\notification";
const profileRoute = "\profile";
const addBookRoute = "\add_book";
const bookDetailRoute = "\book_detail";
const booksListRoute = "\books_list_screen";

// shared preferences key
const userFNameKey = 'first_name';
const userLNameKey = 'last_name';
const userEmailKey = 'email';
const userRoleKey = 'role';
const userUidKey = 'uid';

//role
const adminR = "admin";
const userR = "user";

//one signal id
const appId = "ce001597-0449-43d4-9fe5-e1afda694702";
