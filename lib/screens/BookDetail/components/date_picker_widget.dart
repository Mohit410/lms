import 'package:flutter/material.dart';
import 'package:lms/utils/helper.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({Key? key}) : super(key: key);

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? date;

  @override
  Widget build(BuildContext context) =>
      customButton(() {}, getText(), context, Colors.transparent);

  getText() => date == null
      ? 'Select Date'
      : "${date!.month}/${date!.day}/${date!.year}";

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(initialDate.month + 1),
    );

    if (newDate == null) return;

    setState(() => date = newDate);
  }
}
