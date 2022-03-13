import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lms/model/book_location.dart';
import 'package:lms/model/book_model.dart';
import 'package:lms/model/category_model.dart';
import 'package:lms/repository/data_repository.dart';
import 'package:lms/utils/constants.dart';
import 'package:lms/utils/helper.dart';

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
    tagsFocusNode = FocusNode();
    authorsFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    book = ModalRoute.of(context)?.settings.arguments as Book?;
    if (book != null) {
      bookTitleController.text = book!.title!;
      rackController.text = book!.bookLocation!.rackNo!;
      rowController.text = book!.bookLocation!.rowNo!;
      positionController.text = book!.bookLocation!.position!;
      _direction = book!.bookLocation!.direction!;
      _tagList = book!.tags!;
      _authorsList = book!.authors!;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    tagsFocusNode.dispose();
    authorsFocusNode.dispose();
    super.dispose();
  }

  getCategoryList() async {
    await getCategories().then((value) {
      setState(() {
        _categoryList = value;
      });
    });
  }

  var _isLoading = false;

  List<String> _tagList = [];
  List<String> _authorsList = [];
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

    final rackField = TextFormField(
      controller: rackController,
      textInputAction: TextInputAction.next,
      autofocus: false,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        rackController.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) return "Rack No. cannot be empty";
        return null;
      },
      decoration: InputDecoration(
        floatingLabelAlignment: FloatingLabelAlignment.center,
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.zero,
        label: const Text("Rack No"),
        hintText: "eg. 8",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final rowField = TextFormField(
      controller: rowController,
      textInputAction: TextInputAction.next,
      autofocus: false,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onSaved: (value) {
        rowController.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) return "Row cannot be empty";
        return null;
      },
      decoration: InputDecoration(
        floatingLabelAlignment: FloatingLabelAlignment.center,
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.zero,
        label: const Text("Row No."),
        hintText: "eg. 3",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final positionField = TextFormField(
      controller: positionController,
      textInputAction: TextInputAction.next,
      autofocus: false,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      onSaved: (value) {
        positionController.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) return "Position cannot be empty";
        return null;
      },
      decoration: InputDecoration(
        floatingLabelAlignment: FloatingLabelAlignment.center,
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.zero,
        label: const Text("Position"),
        hintText: "eg. 12",
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
                  fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1),
            )),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              "Right to Left",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1),
            )),
      ],
      isSelected: _directionsList.map((e) => e == _direction).toList(),
      onPressed: (index) {
        setState(() {
          _direction = _directionsList[index];
        });
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

    addBookToCollection() async {
      if (_formKey.currentState!.validate() && _category != null) {
        setState(() {
          _isLoading = true;
        });
        Book _book = Book(
          uid: (book == null) ? "uid" : book!.uid,
          title: bookTitleController.text,
          authors: _authorsList.toSet().toList(),
          tags: _tagList.toSet().toList(),
          category: _category!,
          bookLocation: BookLocation(
              rackNo: rackController.text,
              rowNo: rowController.text,
              position: positionController.text,
              direction: _direction),
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

    return Scaffold(
      appBar: AppBar(
        title: Text((book == null) ? "Add New Book" : "Edit Book"),
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
                              Expanded(child: rackField),
                              const SizedBox(width: 10),
                              Expanded(child: rowField),
                              const SizedBox(width: 10),
                              Expanded(child: positionField)
                            ]),
                        sizedBoxMargin(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Direction", style: TextStyle(fontSize: 16)),
                            directionToggleButtons
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
