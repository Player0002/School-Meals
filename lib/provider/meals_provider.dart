import 'package:flutter/material.dart';
import 'package:school_food/model/meals_model.dart';
import 'package:school_food/model/school_model.dart';
import 'package:school_food/services/search_meals.dart';

enum MealsEnum {
  food_searching,
  end_food_searching,
  error_food_searching,
}

class MealsProvider extends ChangeNotifier {
  MealsEnum _status = MealsEnum.food_searching;
  get status => _status;
  set status(val) {
    _status = val;
    notifyListeners();
  }

  MealsModel meals = MealsModel.empty;

  loadingFood(SchoolDataModel selectedSchool) async {
    status = MealsEnum.food_searching;
    meals = await findMeals(selectedSchool);
    if (meals.isNotEmpty) {
      status = MealsEnum.end_food_searching;
    } else {
      status = MealsEnum.error_food_searching;
    }
  }
}
