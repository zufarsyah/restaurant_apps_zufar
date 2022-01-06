import 'package:flutter/material.dart';
import 'package:restaurant_apps/data/database/database_helper.dart';
import 'package:restaurant_apps/data/model/favorite.dart';
import 'package:restaurant_apps/widget/card_favorite.dart';
import 'package:sqflite/sqflite.dart';

class FavoritePage extends StatefulWidget {
  static const String favoriteTitle = 'Favorite List';
  static const routeName = '/resto_fav';

  @override
  _FavoriteCardState createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<FavoritePage> {
  DbHelper dbHelper = DbHelper();
  late List<Favorite> itemList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => updateListView());
    return Scaffold(
      appBar: AppBar(
        title: Text("Restoran Favorit"),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: 250),
        itemCount: count,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var restaurant = itemList[index];
          return CardGridFav(restaurant: restaurant);
        },
      ),
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Favorite>> itemListFuture = dbHelper.getFavoriteList();
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }
}
