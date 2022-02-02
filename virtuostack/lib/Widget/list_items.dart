import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import 'package:virtuostack/Widget/bottom_sheet_container.dart';
import 'package:virtuostack/Widget/edit_bottom_sheet.dart';
import 'package:virtuostack/model/items_model.dart';

class ListItems extends StatefulWidget {
  ListItems({Key? key}) : super(key: key);

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  // List<int> itemss = List<int>.generate(20, (int index) => index);
  // List<int> items = List<int>.generate(20, (int index) => index);

  @override
  Widget build(BuildContext context) {
    var itemsList = FirebaseFirestore.instance
        .collection('items')
        .orderBy("createdAt", descending: true)
        .withConverter<ItemsModel>(
          fromFirestore: (snapshot, _) => ItemsModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(Duration(seconds: 1), () {
          setState(() {
            final refreshedItemList = FirebaseFirestore.instance
                .collection('items')
                .orderBy("createdAt", descending: true)
                .withConverter<ItemsModel>(
                  fromFirestore: (snapshot, _) =>
                      ItemsModel.fromJson(snapshot.data()!),
                  toFirestore: (user, _) => user.toJson(),
                );
            itemsList = refreshedItemList;
          });
        });
      },
      child: FirestoreListView<ItemsModel>(
          physics: const AlwaysScrollableScrollPhysics(),
          query: itemsList,
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          itemBuilder: (context, snapshot) {
            var item = snapshot.data();

            //for deleting items
            return Dismissible(
              direction: DismissDirection.startToEnd,
              background: Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 10, right: 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              key: ObjectKey(snapshot.data().title),
              onDismissed: (DismissDirection direction) {
                FirebaseFirestore.instance
                    .collection("items")
                    .doc(item.ids.toString())
                    .delete();

                setState(() {
                  final refreshedItemList = FirebaseFirestore.instance
                      .collection('items')
                      .orderBy("createdAt", descending: true)
                      .withConverter<ItemsModel>(
                        fromFirestore: (snapshot, _) =>
                            ItemsModel.fromJson(snapshot.data()!),
                        toFirestore: (user, _) => user.toJson(),
                      );
                  itemsList = refreshedItemList;
                });
              },
              child: list_card(item),
            );
          }),
    );
  }

  Widget list_card(ItemsModel item) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        height: 100,
        child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                item_image(item),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title.toString().length > 20
                            ? item.title.toString().substring(0, 16) + '..'
                            : item.title.toString(),
                        overflow: TextOverflow.fade,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        item.description.toString().length > 20
                            ? item.description.toString().substring(0, 19) +
                                '..'
                            : item.description.toString(),
                        overflow: TextOverflow.fade,
                      )
                    ],
                  ),
                ),
                const Spacer(),
                editbtn(item)
              ],
            )),
      ),
    );
  }

  ClipRRect item_image(ItemsModel item) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
      child: item.image != null
          ? Image.network(
              item.image,
              fit: BoxFit.cover,
              width: 85,
              height: 120,
            )
          : const Image(
              height: 120,
              width: 85,
              image: AssetImage("assets/images/logo.png"),
              fit: BoxFit.cover,
            ),
    );
  }
}

class editbtn extends StatelessWidget {
  editbtn(
    this.item, {
    Key? key,
  }) : super(key: key);
  ItemsModel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 20, top: 22, bottom: 22),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(), primary: Colors.purple.shade50),
          child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const Icon(
                Icons.edit,
                color: Colors.black,
              )),
          onPressed: () => bottonsheet(item, context),
        ));
  }

  Future<dynamic> bottonsheet(ItemsModel item, BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) => EditBottomsheetContainer(item, "Edit Item"));
  }
}
