import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms/main.dart';
import 'package:lms/utils/user_preferences.dart';
import '../../model/book_model.dart';
import '../../repository/data_repository.dart';
import '../../utils/constants.dart';
import '../Home/components/book_card.dart';
import 'components/request_card.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  final tabs = [
    const Tab(text: 'Sent Requests', icon: Icon(Icons.send_rounded)),
    const Tab(text: 'Inventory', icon: Icon(Icons.inventory_2_rounded)),
  ];

  @override
  Widget build(BuildContext context) {
    sentRequestTab(bool isInventory) => StreamBuilder(
          stream: DataRepository().getBooksStream(),
          builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            final data = snapshot.requireData;

            return ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.all(8),
              itemCount: data.size,
              itemBuilder: ((context, index) {
                final book = Book.fromMap(data.docs[index].data());
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      bookDetailRoute,
                      arguments: book.uid,
                    );
                  },
                  child: (admin)
                      ? (book.requestedBy?.uid != null)
                          ? RequestedCard(book)
                          : Container()
                      : (isInventory)
                          ? (book.issuedTo?.uid == UserPreferences.getUserUid())
                              ? BookCard(book)
                              : Container()
                          : (book.requestedBy?.uid ==
                                  UserPreferences.getUserUid())
                              ? BookCard(book)
                              : Container(),
                );
              }),
            );
          }),
        );

    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: (admin)
              ? null
              : AppBar(
                  toolbarHeight: 0,
                  elevation: 0,
                  backgroundColor: Colors.blue,
                  bottom: TabBar(
                    tabs: tabs,
                  ),
                ),
          body: (admin)
              ? sentRequestTab(false)
              : TabBarView(
                  children: [sentRequestTab(false), sentRequestTab(true)],
                ),
        ));
  }
}
