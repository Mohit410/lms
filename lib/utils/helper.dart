import 'package:flutter/material.dart';

headingText(String value) => Text(
      value,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade400,
      ),
      textAlign: TextAlign.start,
    );

fieldText(String value) => Text(
      value,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade200,
      ),
      textAlign: TextAlign.start,
    );

customButton(VoidCallback onPressed, String lable, BuildContext context,
        Color color) =>
    Material(
      elevation: 5,
      color: color,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () => onPressed(),
        child: Text(
          lable,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );

Widget sizedBoxMargin(double value) {
  return SizedBox(height: value);
}
