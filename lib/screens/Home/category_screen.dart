import 'package:flutter/material.dart';
import 'package:lms/utils/constants.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: const Center(
                child: Text(
                  "Select A Category",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              width: MediaQuery.of(context).size.width,
            ),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: const EdgeInsets.all(20),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: categoryList.map((category) {
                return CategoryCard(category: category);
              }).toList(),
            )
          ]),
    );
  }
}
/* 
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? category;
    return Scaffold(
        appBar: null,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: const Center(
                child: Text(
                  "Select A Category",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              width: MediaQuery.of(context).size.width,
            ),
            StreamBuilder(
              stream: DataRepository().getCategoryStream(),
              builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No Books Available"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final data = snapshot.requireData;

                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    category = data.docs[index]);
                    return CategoryCard(category!);
                  },
                );
              }),
            ),
          ],
        ));
  }
}
*/

class CategoryCard extends StatelessWidget {
  final String category;
  const CategoryCard({required this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          booksListRoute,
          arguments: category,
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              category,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
