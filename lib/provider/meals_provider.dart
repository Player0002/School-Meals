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

  MealsSubModel meals = MealsSubModel.empty;
  sideLoading(SchoolDataModel selectedSchool, int left, int right) async {
    try {
      String formated =
          "${selectedSchool.sc_code}${selectedSchool.a_sc_code}${time.year}${time.month}${time.day}";
      if (cache[formated] != null) meals = cache[formated];
      var tmp = time.subtract(Duration(days: 1));
      formated = "${selectedSchool.sc_code}${selectedSchool.a_sc_code}${tmp.year}${tmp.month}${tmp.day}";
      tmp = time.add(Duration(days: 1));
      String formated2 = "${selectedSchool.sc_code}${selectedSchool.a_sc_code}${tmp.year}${tmp.month}${tmp.day}";

      if(cache[formated] != null && cache[formated2] != null) return;
      MealsModel meal = await findMeals(selectedSchool, time);
      if (meal.isNotEmpty) {
        if (cache.length > 100) {
          for (int i = 0; i < 3; i++)
            cache.remove(left < right
                ? cache.keys.toList().last
                : cache.keys.toList().first);
        }
        for (MealsSubModel m in meal.meals) {
          print("SET CACHE : ${m.date.year}${m.date.month}${m.date.day}");
          String formated =
              "${selectedSchool.sc_code}${selectedSchool.a_sc_code}${m.date.year}${m.date.month}${m.date.day}";
          cache[formated] = m;
        }
      }
    } on Exception {
      status = MealsEnum.error_food_searching;
    }
  }

  loadingFood(SchoolDataModel selectedSchool, int left, int right) async {
    status = MealsEnum.food_searching;
    try {
      String formated =
          "${selectedSchool.sc_code}${selectedSchool.a_sc_code}${time.year}${time.month}${time.day}";
      if (cache[formated] != null) {
        meals = cache[formated];
        status = MealsEnum.end_food_searching;
        return;
      }
      print("Call meals. cause cache is not found.");
      MealsModel meal = await findMeals(selectedSchool, time);
      if (meal.isNotEmpty) {
        if (cache.length > 100) {
          for (int i = 0; i < 3; i++)
            cache.remove(left < right
                ? cache.keys.toList().last
                : cache.keys.toList().first);
        }
        for (MealsSubModel m in meal.meals) {
          print("SET CACHE : ${m.date.year}${m.date.month}${m.date.day}");
          String formated =
              "${selectedSchool.sc_code}${selectedSchool.a_sc_code}${m.date.year}${m.date.month}${m.date.day}";
          cache[formated] = m;
        }
        if (cache[formated] == null) cache[formated] = MealsSubModel.empty;
        meals = cache[formated];

        status = MealsEnum.end_food_searching;
      } else {
        cache[formated] = MealsSubModel.empty;
        status = MealsEnum.end_food_searching;
      }
    } on Exception {
      status = MealsEnum.error_food_searching;
    }
  }
}
