import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_apps/data/model/restaurant.dart';

var testing = {
  "id": "rqdv5juczeskfw1e867",
  "name": "Melting Pot",
  "description":
      "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
  "pictureId": "14",
  "city": "Medan",
  "rating": 4.2
};

void main() {
  test("Test Parsing", () async {
    var result = Restaurant.fromJson(testing).id;
    expect(result, "rqdv5juczeskfw1e867");
  });
}
