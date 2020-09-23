import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_food/constants/constants.dart';
import 'package:school_food/model/meals_model.dart';
import 'package:school_food/model/school_model.dart';

Future<MealsModel> findMeals(SchoolDataModel school) async {
  try {
    final response = await http.get(
      "$baseUrl/meals?AD_CODE=${school.a_sc_code}&SC_CODE=${school.sc_code}",
    );
    if (response.statusCode == 200) {
      return MealsModel.fromJson(json.decode(response.body));
    } else {
      return MealsModel.empty;
    }
  } on Exception {
    throw Exception("Server connection error.");
  }
}
