import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:school_food/constants/constants.dart';
import 'package:school_food/model/school_model.dart';

Future<SchoolModel> findSchool(String schoolName) async {
  try {
    final response = await http.get("$baseUrl/school?name=$schoolName");
    if (response.statusCode == 200) {
      return SchoolModel.fromJson(json.decode(response.body));
    } else {
      return SchoolModel.empty;
    }
  } on Exception {
    throw Exception("Server connection error.");
  }
}
