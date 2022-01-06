import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_apps/data/api/api_detail.dart';
import 'package:restaurant_apps/data/database/database_helper.dart';
import 'package:restaurant_apps/data/model/favorite.dart';
import 'package:restaurant_apps/data/model/restaurant.dart' as RestaurantData;
import 'package:restaurant_apps/provider/detail_restaurant_provider.dart';
import 'package:sqflite/sqflite.dart';

class DetailScreenFav extends StatefulWidget {
  static const routeName = '/resto_detail_fav';
  final Favorite data;
  const DetailScreenFav({Key? key, required this.data}) : super(key: key);

  @override
  _DetailScreenFav createState() => _DetailScreenFav();
}

class _DetailScreenFav extends State<DetailScreenFav> {
  int count = 0;
  bool stateTombol = false;
  DbHelper dbHelper = DbHelper();
  late List<Favorite> itemList;
  late final Favorite favorite;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.remove,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Alert'),
                  content: const Text(
                      'Apakah anda ingin menghapus resto dari favorit?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Tidak'),
                      child: const Text('Tidak'),
                    ),
                    TextButton(
                      onPressed: () {
                        dbHelper.delete(widget.data.id!);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Remove From Favorite"),
                        ));
                        Navigator.pop(context);
                      },
                      child: const Text('Ya'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: DetailPage(dataFav: widget.data),
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

class DetailPage extends StatefulWidget {
  Favorite dataFav;

  DetailPage({required this.dataFav});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return _buildDetail();
  }

  Widget _buildDetail() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                ),
              ),
              child: Image.network(
                  'https://restaurant-api.dicoding.dev/images/medium/' +
                      widget.dataFav.urlImage!),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.dataFav.name!,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 20,
                      ),
                      Text(
                        widget.dataFav.city!,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 20,
                      ),
                      Text(
                        widget.dataFav.rating.toString(),
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.dataFav.desc!,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
