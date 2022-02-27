import 'package:flutter/material.dart';
import 'package:lms/model/book_model.dart';
import 'package:lms/model/category_model.dart';
import 'package:lms/repository/data_repository.dart';
import 'package:lms/screens/AddBook/components/category_dropdown.dart';
import 'package:lms/utils/constants.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  var _isLoading = false;

  final List<String> _tagList = [];
  final List<String> _authorsList = [];
  final List<String> _categoryList = [];
  Category? _category;

  final bookTitleController = TextEditingController();
  final bookAuthorController = TextEditingController();
  final categoryController = TextEditingController();
  final tagsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final titleField = TextFormField(
      controller: bookTitleController,
      textInputAction: TextInputAction.next,
      autofocus: false,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        bookTitleController.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) return "Title cannot be empty";
        if (value.length < 3) {
          return "Min 3 character required";
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.title),
        contentPadding: EdgeInsets.zero,
        label: const Text("Title"),
        hintText: "Enter Book Title",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final authorTagField = TextFieldTags(
      initialTags: _authorsList,
      textSeparators: const [","],
      tagsStyler: TagsStyler(
        tagTextStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        tagCancelIcon: const Icon(
          Icons.cancel,
          color: Colors.black,
        ),
        tagDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.red.shade200,
        ),
      ),
      textFieldStyler: TextFieldStyler(
        hintText: "Enter Author Names",
        helperText: "",
        textFieldBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onTag: (tag) {
        setState(() {
          _authorsList.add(tag);
        });
      },
      onDelete: (tag) {
        setState(() {
          _authorsList.remove(tag);
        });
      },
      validator: (tag) {
        if (tag.isEmpty) return "Auhtor name cannot be empty";
        if (tag.length < 3) {
          return "Min 3 character required";
        }
        return null;
      },
    );

    final categoryDropdownBtn = CategoryDropDown(
      _category,
      onCategoryChanged: (value) {
        _category = value;
      },
    );

    final categoryField = TextFormField(
      controller: categoryController,
      textInputAction: TextInputAction.next,
      autofocus: false,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        categoryController.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) return "Category cannot be empty";
        if (value.length < 3) {
          return "Min 3 character required";
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.category_rounded),
        contentPadding: EdgeInsets.zero,
        label: const Text("Category"),
        hintText: "Enter Book Category",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final tagsField = TextFieldTags(
      initialTags: _tagList,
      textSeparators: const [","],
      tagsStyler: TagsStyler(
        tagTextStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        tagCancelIcon: const Icon(
          Icons.cancel,
          color: Colors.black,
        ),
        tagDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.red.shade200,
        ),
      ),
      textFieldStyler: TextFieldStyler(
        hintText: "Enter Associated Tags",
        helperText: "",
        textFieldBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onTag: (tag) {
        setState(() {
          _tagList.add(tag);
        });
      },
      onDelete: (tag) {
        setState(() {
          _tagList.remove(tag);
        });
      },
    );

    addBookToCollection() async {
      setState(() {
        _isLoading = true;
      });
      Book book = Book(
        uid: "uid",
        title: bookTitleController.text,
        authors: _authorsList.toSet().toList(),
        tags: _tagList.toSet().toList(),
        category: _category!,
        status: "in",
        issuedTo: null,
      );

      DataRepository().addBook(book).then((value) {
        setState(() {
          _isLoading = false;
        });
        showSnackbar("Book added successfully", context);
        Navigator.pop(context);
      });
    }

    final submitButton = Material(
      elevation: 5,
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (() {
          addBookToCollection();
        }),
        child: const Text(
          "Submit",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    Widget sizedBoxMargin(double value) {
      return SizedBox(height: value);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Book"),
      ),
      body: Center(
        child: (_isLoading)
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        titleField,
                        sizedBoxMargin(20),
                        categoryDropdownBtn,
                        sizedBoxMargin(20),
                        authorTagField,
                        tagsField,
                        submitButton
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
