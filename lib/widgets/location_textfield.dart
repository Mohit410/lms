import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocationTextField extends StatelessWidget {
  final TextEditingController controller;
  final String lable;
  const LocationTextField({
    Key? key,
    required this.controller,
    required this.lable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      autofocus: false,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (value) {
        controller.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) return "$lable cannot be empty";
        return null;
      },
      decoration: InputDecoration(
        floatingLabelAlignment: FloatingLabelAlignment.center,
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        label: Text("$lable No."),
        hintText: "eg. 12",
        errorMaxLines: 3,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
