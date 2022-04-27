import 'package:flutter/material.dart';
import 'package:lms/model/book_location.dart';
import 'package:lms/model/book_model.dart';
import 'package:lms/repository/data_repository.dart';
import 'package:lms/utils/constants.dart';
import 'package:lms/utils/helper.dart';
import 'package:lms/widgets/drop_down_widget.dart';
import 'package:lms/widgets/location_textfield.dart';

class AddBookScreen extends StatefulWidget {
  final Book? book;
  const AddBookScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  Book? _book;
  @override
  void initState() {
    super.initState();
    tagsFocusNode = FocusNode();
    authorsFocusNode = FocusNode();
    _book = widget.book;

    if (_book != null) {
      bookTitleController.text = _book!.title!;
      rackController.text = _book!.bookLocation!.rackNo!;
      rowController.text = _book!.bookLocation!.rowNo!;
      positionController.text = _book!.bookLocation!.position!;
      _direction = _book!.bookLocation!.direction!;
      _tagList = _book!.tags!;
      _authorsList = _book!.authors!;
      _category = _book!.category!;
    }
  }

  @override
  void dispose() {
    tagsFocusNode.dispose();
    authorsFocusNode.dispose();
    bookTitleController.dispose();
    authorController.dispose();
    tagsController.dispose();
    rackController.dispose();
    rowController.dispose();
    positionController.dispose();
    super.dispose();
  }

  var _isLoading = false;

  List<String> _tagList = [];
  List<String> _authorsList = [];
  String? _category;

  final _formKey = GlobalKey<FormState>();

  final bookTitleController = TextEditingController(text: "");
  final authorController = TextEditingController();
  final tagsController = TextEditingController();
  final rackController = TextEditingController();
  final rowController = TextEditingController();
  final positionController = TextEditingController();

  String _direction = "";
  final List<String> _directionsList = ["L2R", "R2L"];

  late FocusNode tagsFocusNode;
  late FocusNode authorsFocusNode;

  int setBookCount = 0;

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
      autovalidateMode: AutovalidateMode.onUserInteraction,
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

    getTagInputChip(String value) => InputChip(
          label: Text(value),
          labelStyle: const TextStyle(fontSize: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          deleteIcon: const Icon(Icons.cancel),
          onDeleted: () {
            setState(() {
              _tagList.remove(value);
            });
          },
        );

    final tagListContainer = Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children: _tagList.map((e) => getTagInputChip(e)).toList(),
        ));

    final tagsTextField = TextFormField(
      keyboardType: TextInputType.name,
      focusNode: tagsFocusNode,
      controller: tagsController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        setState(() {
          if (value.isNotEmpty) {
            _tagList.add(value);
          }
        });
        tagsController.text = "";
        tagsFocusNode.requestFocus();
      },
      validator: (_) {
        if (_tagList.isEmpty) return "Tags cannot be empty";
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.tag_rounded),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          helperText:
              (tagsFocusNode.hasFocus) ? "Press Enter to Add Tag" : null,
          labelText: 'Tags',
          hintText: "eg. Java, android",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    getAuthorInputChip(String value) => InputChip(
          label: Text(value),
          labelStyle: const TextStyle(fontSize: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          deleteIcon: const Icon(Icons.cancel),
          onDeleted: () {
            setState(() {
              _authorsList.remove(value);
            });
          },
        );

    final authorListContainer = Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children: _authorsList.map((e) => getAuthorInputChip(e)).toList(),
        ));

    final authorTextField = TextFormField(
      keyboardType: TextInputType.name,
      focusNode: authorsFocusNode,
      controller: authorController,
      onFieldSubmitted: (value) {
        setState(() {
          if (value.isNotEmpty) {
            _authorsList.add(value);
          }
        });
        authorController.text = "";
        authorsFocusNode.requestFocus();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_) {
        if (_authorsList.isEmpty) return "Author cannot be empty";
        return null;
      },
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person_rounded),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'eg. Andrew Ng',
          helperText:
              (authorsFocusNode.hasFocus) ? "Press Enter to Add Author" : null,
          labelText: "Authors",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final directionToggleButtons = ToggleButtons(
      children: const [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              "Left to Right",
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1),
            )),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              "Right to Left",
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1),
            )),
      ],
      isSelected: _directionsList.map((e) => e == _direction).toList(),
      onPressed: (index) {
        setState(() {
          _direction = _directionsList[index];
        });
      },
    );

    // validating function

    addBookToCollection() async {
      if (_formKey.currentState!.validate() && _category != null) {
        setState(() {
          _isLoading = true;
        });
        Book book = Book(
          uid: (_book == null) ? "uid" : _book!.uid,
          title: bookTitleController.text,
          authors: _authorsList.toSet().toList(),
          tags: _tagList.toSet().toList(),
          category: _category,
          bookLocation: BookLocation(
              rackNo: rackController.text,
              rowNo: rowController.text,
              position: positionController.text,
              direction: _direction),
        );

        final result = (_book == null)
            ? DataRepository().addBook(book)
            : DataRepository().updateBook(book);

        await result.then(
          (value) {
            showSnackbar(
                (_book == null)
                    ? "Book added successfully"
                    : "Book Updated Successfully",
                context);
            Navigator.pop(context);
          },
        ).catchError((error) {
          showSnackbar("Something went wrong", context);
        });
      }
      setState(() {
        _isLoading = false;
      });
    }

    void onCategoryChanged(String value) {
      setState(() {
        _category = value;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text((_book == null) ? "Add New Book" : "Edit Book"),
        backgroundColor: Colors.blue,
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
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text("Category"),
                        ),
                        sizedBoxMargin(10),
                        CustomDropDownFormField(
                          itemList: categoryList,
                          onItemChanged: (value) {
                            onCategoryChanged(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select a category";
                            }
                            return null;
                          },
                          currentValue: _category,
                          hint: "Select A Category",
                        ),
                        sizedBoxMargin(20),
                        authorListContainer,
                        sizedBoxMargin(8),
                        authorTextField,
                        sizedBoxMargin(20),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text("Location"),
                        ),
                        sizedBoxMargin(10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: LocationTextField(
                                      controller: rackController,
                                      lable: "Rack")),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: LocationTextField(
                                      controller: rowController, lable: "Row")),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: LocationTextField(
                                      controller: positionController,
                                      lable: "Position"))
                            ]),
                        sizedBoxMargin(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Direction",
                                style: TextStyle(fontSize: 16)),
                            directionToggleButtons,
                          ],
                        ),
                        sizedBoxMargin(20),
                        tagListContainer,
                        sizedBoxMargin(8),
                        tagsTextField,
                        sizedBoxMargin(40),
                        customButton(addBookToCollection, "Submit", context,
                            redButtonColor),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
