import 'package:flutter/material.dart';
import 'package:school_food/model/meals_model.dart';
import 'package:school_food/model/school_model.dart';
import 'package:school_food/services/search_meals.dart';

enum MealsEnum {
  food_searching,
  end_food_searching,
  error_food_searching,
}
final cache = {};

class MealsProvider extends ChangeNotifier {
  MealsEnum _status = MealsEnum.food_searching;
  DateTime _time = DateTime.now();
  get status => _status;
  set status(val) {
    _status = val;
    notifyListeners();
  }

  DateTime get time => _time;
  set time(val) {
    _time = val;
    notifyListeners();
  }

  MealsModel meals = MealsModel.empty;

  loadingFood(SchoolDataModel selectedSchool) async {
    status = MealsEnum.food_searching;
    final formated =
        "${selectedSchool.sc_code}${selectedSchool.a_sc_code}${time.year}${time.month}${time.day}";
    if (cache[formated] != null) {
      meals = cache[formated];
      status = MealsEnum.end_food_searching;
      return;
    }
    meals = await findMeals(selectedSchool, time);
    if (meals.isNotEmpty) {
      if (cache.length > 10) cache.remove(cache.keys.toList()[0]);
      cache[formated] = meals;
      status = MealsEnum.end_food_searching;
    } else {
      status = MealsEnum.error_food_searching;
    }
  }
}
