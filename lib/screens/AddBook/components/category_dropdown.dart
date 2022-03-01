import 'package:flutter/material.dart';
import 'package:lms/model/category_model.dart';
import 'package:lms/repository/data_repository.dart';

class CategoryDropDown extends StatefulWidget {
  Category? _category;
  final Function(Category) onCategoryChanged;
  CategoryDropDown(this._category, {Key? key, required this.onCategoryChanged})
      : super(key: key);

  @override
  State<CategoryDropDown> createState() => _CategoryDropDownState();
}

class _CategoryDropDownState extends State<CategoryDropDown> {
  List<Category> categoryList = [];

  Category? category;

  @override
  void initState() {
    super.initState();
    setState(() {
      category = widget._category;
      if (category != null) widget.onCategoryChanged(category!);
    });
    getCategories().then((value) {
      setState(() {
        categoryList = value;
      });
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
    getCategories();
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      padding: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        child: DropdownButton<Category>(
          hint: const Text("Select Category"),
          onChanged: (value) {
            setState(() {
              widget._category = value;
              category = value;
              widget.onCategoryChanged(value!);
            });
          },
          value: category,
          items: categoryList.map<DropdownMenuItem<Category>>(
            (value) {
              return DropdownMenuItem<Category>(
                value: value,
                child: SizedBox(
                  width: width * .50,
                  child: Text(
                    "${value.title}",
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
