import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_food/constants/constants.dart';
import 'package:school_food/model/meals_model.dart';
import 'package:school_food/model/school_model.dart';

Future<MealsModel> findMeals(SchoolDataModel school, DateTime time) async {
  try {
    final subTime = time.subtract(Duration(days: 1));
    final extTime = time.add(Duration(days: 1));
    final fixedUrl =
        "$baseUrl/lotMeals?AD_CODE=${school.a_sc_code}&SC_CODE=${school.sc_code}&START=${subTime.millisecondsSinceEpoch}&END=${extTime.millisecondsSinceEpoch}";
    print(fixedUrl);
    print(
        "START : ${time.subtract(Duration(days: 1))} END : ${(time.add(Duration(days: 1)))}");
    final response = await http.get(fixedUrl);
    if (response.statusCode == 200) {
      print(response.body);
      return MealsModel.fromJson(json.decode(response.body));
    } else {
      return MealsModel.empty;
    }
  } on Exception {
    print(StackTrace.current);
    throw Exception("Server connection error.");
  }
}
