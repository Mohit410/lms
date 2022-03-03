import 'package:flutter/material.dart';
import 'package:lms/model/book_model.dart';
import 'package:lms/model/category_model.dart';
import 'package:lms/repository/data_repository.dart';
import 'package:lms/utils/constants.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  Book? book = Book();

  @override
  void initState() {
    super.initState();
    setState(() {
      _category = book?.category;
    });

    getCategoryList();
  }

  getCategoryList() async {
    await getCategories().then((value) {
      setState(() {
        _categoryList = value;
      });
    });
  }

  var _isLoading = false;

  final List<String> _tagList = [];
  final List<String> _authorsList = [];
  List<Category> _categoryList = [];
  Category? _category;

  final _formKey = GlobalKey<FormState>();

  Future<List<Category>> getCategories() async {
    var qShot = await DataRepository().categoriesCollection.get();

    return qShot.docs
        .map((doc) => Category(uid: doc.get('uid'), title: doc.get('title')))
        .toList();
  }

  final bookTitleController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    setState(() {
      book = ModalRoute.of(context)?.settings.arguments as Book?;
      if (book != null) {
        bookTitleController.text = book!.title!;
        _tagList.addAll(book!.tags!);
        _authorsList.addAll(book!.authors!);
      }
    });

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
      initialTags: book?.authors ?? _authorsList,
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
          color: Colors.red.shade400,
        ),
      ),
      textFieldStyler: TextFieldStyler(
        hintText: "Enter Author Names",
        helperText: "Enter , to seperate Authors",
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

    final categoryDropdownBtn = Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton<Category>(
              underline: Container(),
              isExpanded: true,
              items: _categoryList.map<DropdownMenuItem<Category>>((cate) {
                return DropdownMenuItem<Category>(
                  value: cate,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Text(
                      "${cate.title}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
              value: _category,
              onChanged: (value) {
                setState(() {
                  _category = value;
                });
              },
            )));

    final tagsField = TextFieldTags(
      initialTags: book?.tags ?? _tagList,
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
          color: Colors.red.shade400,
        ),
      ),
      textFieldStyler: TextFieldStyler(
        hintText: "Enter Associated Tags",
        helperText: "Enter , to separate tags",
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
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        Book _book = Book(
          uid: (book == null) ? "uid" : book!.uid,
          title: bookTitleController.text,
          authors: _authorsList.toSet().toList(),
          tags: _tagList.toSet().toList(),
          category: _category!,
          status: "in",
        );

        final result = (book == null)
            ? DataRepository().addBook(_book)
            : DataRepository().updateBook(_book);

        await result.then(
          (value) {
            setState(() {
              _isLoading = false;
            });
            showSnackbar(
                (book == null)
                    ? "Book added successfully"
                    : "Book Updated Successfully",
                context);
            Navigator.pop(context);
          },
        ).catchError((error) {
          setState(() {
            _isLoading = false;
          });
          showSnackbar("Something went wrong", context);
        });
      }
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
                        sizedBoxMargin(20),
                        tagsField,
                        sizedBoxMargin(40),
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
