import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms/model/user_model.dart';
import 'package:lms/utils/constants.dart';

class EditForm extends StatefulWidget {
  UserModel userModel = UserModel();
  final VoidCallback onSaveClicked;
  final VoidCallback onCancelClicked;

  EditForm({
    Key? key,
    required this.userModel,
    required this.onSaveClicked,
    required this.onCancelClicked,
  }) : super(key: key);

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  var firstNameController = TextEditingController();

  var lastNameController = TextEditingController();

  @override
  void initState() {
    firstNameController =
        TextEditingController(text: widget.userModel.firstName);
    lastNameController = TextEditingController(text: widget.userModel.lastName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future updateUserData() {
      setState(() {
        _isLoading = true;
      });
      return FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userModel.uid)
          .update(
        {
          'first_name': firstNameController.text,
          'last_name': lastNameController.text
        },
      ).then((value) {
        setState(() {
          _isLoading = true;
        });
        showSnackbar("User details updated successfully", context);
        widget.onSaveClicked();
      }).catchError((error) {
        showSnackbar(error.toString(), context);
      });
    }

    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameController,
      keyboardType: TextInputType.name,
      //validator: () {},
      onSaved: (value) {
        firstNameController.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "First name cannot be empty";
        }
        RegExp regex = RegExp(r"^.{3,}$");
        if (!regex.hasMatch(value)) {
          return "Enter valid name(Min. 3 characters)";
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'First Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

//last name field
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameController,
      keyboardType: TextInputType.name,
      //validator: () {},
      onSaved: (value) {
        lastNameController.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Last name cannot be empty";
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Last Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //Save Button
    final saveButton = Material(
      elevation: 5,
      color: Colors.blue.shade800,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          updateUserData();
        },
        child: const Text(
          "SAVE",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final cancelButton = Material(
      elevation: 5,
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          widget.onCancelClicked();
        },
        child: const Text(
          "CANCEL",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );

    Widget sizedBoxMargin(double value) {
      return SizedBox(height: value);
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          firstNameField,
          sizedBoxMargin(20),
          lastNameField,
          sizedBoxMargin(30),
          cancelButton,
          sizedBoxMargin(20),
          saveButton,
          sizedBoxMargin(40),
        ],
      ),
    );
  }
}
