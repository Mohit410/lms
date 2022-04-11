import 'package:flutter/material.dart';

class CustomInputChipGroupWidget extends StatelessWidget {
  final List<String> list;
  final Function(String) removeTag;
  const CustomInputChipGroupWidget({
    Key? key,
    required this.list,
    required this.removeTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getInputChip(String value) => InputChip(
          label: Text(value),
          labelStyle: const TextStyle(fontSize: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          deleteIcon: const Icon(Icons.cancel),
          onDeleted: () {
            removeTag(value);
          },
        );

    return Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children: list.map((e) => getInputChip(e)).toList(),
        ));
  }
}
