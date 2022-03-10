import 'package:flutter/material.dart';
import 'package:lms/model/category_model.dart';
import 'package:lms/repository/data_repository.dart';
import 'package:lms/utils/constants.dart';

class CategoryDropDown extends StatefulWidget {
  Category? _category;
  Function(Category) onCategoryChanged;
  CategoryDropDown(
    this._category, {
    Key? key,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  State<CategoryDropDown> createState() => _CategoryDropDownState();
}

class _CategoryDropDownState extends State<CategoryDropDown> {
  List<Category> categoryList = [];

  Category? category;

  @override
  void initState() {
    super.initState();
    getCategories().then((value) {
      setState(() {
        categoryList = value;
      });
    });
    setState(() {
      category = widget._category;
      if (category != null) widget.onCategoryChanged(category!);
    });
  }

  Future<List<Category>> getCategories() async {
    var qShot = await DataRepository().categoriesCollection.get();

    return qShot.docs
        .map((doc) => Category(uid: doc.get('uid'), title: doc.get('title')))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        child: DropdownButton<Category>(
          hint: const Text(
            "Select Category",
            style: TextStyle(color: blueButtonColor),
          ),
          isExpanded: true,
          onChanged: (value) {
            setState(() {
              if (value != null) {
                widget._category = value;
                category = value;
                widget.onCategoryChanged(value);
              }
            });
          },
          value: category ?? categoryList[0],
          items: categoryList.map<DropdownMenuItem<Category>>(
            (cate) {
              return DropdownMenuItem<Category>(
                value: cate,
                child: SizedBox(
                  width: width * .50,
                  child: Text(
                    "${cate.title}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
