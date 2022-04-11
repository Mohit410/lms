import 'package:flutter/material.dart';

class CustomDropDownFormField extends StatelessWidget {
  final List<String> itemList;
  final String? currentValue;
  final String hint;
  final Function(String) onItemChanged;
  final Function(String?) validator;

  const CustomDropDownFormField(
      {Key? key,
      required this.itemList,
      required this.onItemChanged,
      required this.currentValue,
      required this.hint,
      required this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
              isExpanded: true,
              items: itemList.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Text(
                      item,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => validator(value),
              value: currentValue,
              onChanged: (value) => onItemChanged(value!),
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.category_rounded),
                  labelText: hint),
            ))));
  }
}
