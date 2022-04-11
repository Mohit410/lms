import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms/model/user_model.dart';
import 'package:lms/utils/constants.dart';
import 'package:lms/utils/helper.dart';

class EditForm extends StatefulWidget {
  final UserModel userModel;
  final VoidCallback onSaveClicked;
  final VoidCallback onCancelClicked;

  const EditForm({
    Key? key,
    required this.userModel,
    required this.onSaveClicked,
    required this.onCancelClicked,
  }) : super(key: key);

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
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
    updateUserData() async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userModel.uid)
          .update(
        {
          'first_name': firstNameController.text,
          'last_name': lastNameController.text
        },
      ).then((value) {
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
          customButton(
              widget.onCancelClicked, "CANCEL", context, redButtonColor),
          sizedBoxMargin(20),
          customButton(updateUserData, "SAVE", context, blueButtonColor),
          sizedBoxMargin(40),
        ],
      ),
    );
  }
}
