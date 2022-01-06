import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_apps/data/api/api_detail.dart';
import 'package:restaurant_apps/data/database/database_helper.dart';
import 'package:restaurant_apps/data/model/favorite.dart';
import 'package:restaurant_apps/data/model/restaurant.dart' as RestaurantData;
import 'package:restaurant_apps/data/model/restaurant_detail.dart';
import 'package:restaurant_apps/provider/detail_restaurant_provider.dart';
import 'package:sqflite/sqflite.dart';

class DetailScreen extends StatefulWidget {
  static const routeName = '/resto_detail';
  final RestaurantData.Restaurant data;
  const DetailScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen> {
  int count = 0;
  bool stateTombol = false;
  DbHelper dbHelper = DbHelper();
  late List<Favorite> itemList;
  late final Favorite favorite;
  int _selectedIndex = 0;
  List titleApps = ["Detail", "Foods", "Drinks", "Reviews"];
  List<Widget> _widgetOptions() => [
        DetailPage(),
        FoodsPage(),
        DrinksPage(),
        ReviewPage(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOption = _widgetOptions();
    return ChangeNotifierProvider<DetailRestaurantProvider>(
      create: (_) => DetailRestaurantProvider(
        apiDetail: ApiDetail(idDetail: widget.data.id),
      ),
      child: Consumer<DetailRestaurantProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.HasData) {
            var restaurantDetail = state.result.restaurant;
            return Scaffold(
              appBar: AppBar(
                title: Text(titleApps[_selectedIndex]),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Alert'),
                          content: const Text(
                              'Apakah anda ingin menambahkan resto ke favorit?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Tidak'),
                              child: const Text('Tidak'),
                            ),
                            TextButton(
                              onPressed: () async {
                                favorite = Favorite(
                                    idFavorite: restaurantDetail.id,
                                    name: restaurantDetail.name,
                                    desc: restaurantDetail.description,
                                    urlImage: restaurantDetail.pictureId,
                                    city: restaurantDetail.city,
                                    rating: restaurantDetail.rating.toString(),
                                    address: restaurantDetail.address,
                                    isFav: '1');
                                int result = await dbHelper.insert(favorite);
                                if (result > 0) {
                                  updateListView();
                                }
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Add To Favorite"),
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
              body: Center(
                child: widgetOption.elementAt(_selectedIndex),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.format_list_bulleted),
                    label: 'Detail',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.lunch_dining),
                    label: 'Food',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.local_cafe),
                    label: 'Drink',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.drive_file_rename_outline_outlined),
                    label: 'Review',
                  ),
                ],
                currentIndex: _selectedIndex,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.amber[800],
                onTap: _onItemTapped,
              ),
            );
          } else if (state.state == ResultState.NoData) {
            return Center(child: Text(state.message));
          } else if (state.state == ResultState.Error) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text(''));
          }
        },
      ),
    );
    ;
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
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return _buildDetail();
  }

  Widget _buildDetail() {
    return Consumer<DetailRestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          var restaurantDetail = state.result.restaurant;
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
                            restaurantDetail.pictureId),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          restaurantDetail.name,
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
                              restaurantDetail.city,
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
                              restaurantDetail.rating.toString(),
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
                          restaurantDetail.description,
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
        } else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text(''));
        }
      },
    );
  }
}

class FoodsPage extends StatefulWidget {
  @override
  _FoodsPageState createState() => _FoodsPageState();
}

class _FoodsPageState extends State<FoodsPage> {
  @override
  Widget build(BuildContext context) {
    return _buildFood();
  }

  Widget _buildFood() {
    return Consumer<DetailRestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          return Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: state.result.restaurant.menus.foods.map((food) {
                  return Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(food.name),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        } else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text(''));
        }
      },
    );
  }
}

class DrinksPage extends StatefulWidget {
  @override
  _DrinksPageState createState() => _DrinksPageState();
}

class _DrinksPageState extends State<DrinksPage> {
  @override
  Widget build(BuildContext context) {
    return _buildDrink();
  }

  Widget _buildDrink() {
    return Consumer<DetailRestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          return Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: state.result.restaurant.menus.drinks.map((drink) {
                  return Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(drink.name),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        } else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text(''));
        }
      },
    );
  }
}

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return _buildDrink();
  }

  Widget _buildDrink() {
    return Consumer<DetailRestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          var restaurantDetail = state.result.restaurant;
          return ListView.builder(
            itemCount: restaurantDetail.customerReviews.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          'Name: ${restaurantDetail.customerReviews[index].name}'),
                      Text(
                          'Date: ${restaurantDetail.customerReviews[index].date}'),
                      Text(
                          'Review: ${restaurantDetail.customerReviews[index].review}'),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text(''));
        }
      },
    );
  }
}
