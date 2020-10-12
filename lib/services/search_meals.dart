import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_food/constants/constants.dart';
import 'package:school_food/model/meals_model.dart';
import 'package:school_food/model/school_model.dart';

Future<MealsModel> findMeals(SchoolDataModel school, DateTime time) async {
  try {
    print("$baseUrl/lotMeals?AD_CODE=${school.a_sc_code}&SC_CODE=${school.sc_code}&START=${(time.subtract(Duration(days: 1))).millisecondsSinceEpoch}&END=${(time.add(Duration(days: 1))).millisecondsSinceEpoch}");
    print(
        "START : ${time.subtract(Duration(days: 1)).day} END : ${(time.add(Duration(days: 1))).day}");
    final response = await http.get(
      "$baseUrl/lotMeals?AD_CODE=${school.a_sc_code}&SC_CODE=${school.sc_code}&START=${(time.subtract(Duration(days: 1))).millisecondsSinceEpoch}&END=${(time.add(Duration(days: 1))).millisecondsSinceEpoch}",
    );
    if (response.statusCode == 200) {
      return MealsModel.fromJson(json.decode(response.body));
    } else {
      return MealsModel.empty;
    }
  } on Exception {
    print(StackTrace.current);
    throw Exception("Server connection error.");
  }
}
