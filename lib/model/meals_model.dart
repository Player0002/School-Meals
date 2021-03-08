import 'package:equatable/equatable.dart';

class MealsModel {
  final List<MealsSubModel> meals;

  static MealsModel empty = MealsModel(meals: List.empty());

  bool get isNotEmpty => meals.length > 0;

  MealsModel({this.meals});

  MealsSubModel getFromDate(DateTime time) {
    if (meals != null)
      for (MealsSubModel element in meals) {
        if (element.date.year == time.year &&
            element.date.month == time.month &&
            element.date.day == time.day) return element;
      }
    return MealsSubModel.empty;
  }

  factory MealsModel.fromJson(Map<String, dynamic> json) {
    return MealsModel(
      meals: (json["result"] as List)
          .map((e) => MealsSubModel.fromJson(e))
          .toList(),
    );
  }
}

class MealsSubModel extends Equatable {
  MealsSubModel({this.date, this.breakfast, this.lunch, this.dinner});

  bool get isNotEmpty =>
      breakfast != MealsDataModel.empty &&
      lunch != MealsDataModel.empty &&
      dinner != MealsDataModel.empty;

  static MealsSubModel empty = MealsSubModel(
    breakfast: MealsDataModel.empty,
    lunch: MealsDataModel.empty,
    dinner: MealsDataModel.empty,
  );
  final DateTime date;
  final MealsDataModel breakfast;
  final MealsDataModel lunch;
  final MealsDataModel dinner;

  isEmpty(idx) {
    if (idx == 0)
      return breakfast.cal == null &&
          breakfast.lists == null &&
          breakfast.NTR == null;
    if (idx == 1)
      return lunch.cal == null && lunch.lists == null && lunch.NTR == null;
    if (idx == 2)
      return dinner.cal == null && dinner.lists == null && dinner.NTR == null;
    return false;
  }

  MealsDataModel getFromIdx(idx) {
    if (idx == 0) return breakfast;
    if (idx == 1) return lunch;
    if (idx == 2) return dinner;
    return null;
  }

  factory MealsSubModel.fromJson(Map<String, dynamic> json) {
    int value = int.parse(json["date"]);
    return MealsSubModel(
      date: DateTime(value ~/ 10000, (value ~/ 100) % 100, value % 100),
      breakfast: MealsDataModel.fromJson(json["breakfast"]),
      lunch: MealsDataModel.fromJson(json["lunch"]),
      dinner: MealsDataModel.fromJson(json["dinner"]),
    );
  }

  @override
  List<Object> get props => [breakfast, dinner, lunch];
}

class MealsDataModel extends Equatable {
  @override
  List<Object> get props => [lists, cal, NTR];
  final List<String> lists;
  final String cal;
  final List<String> NTR;

  MealsDataModel({this.lists, this.cal, this.NTR});

  static MealsDataModel empty =
      MealsDataModel(lists: null, cal: null, NTR: null);
  static MealsDataModel loading =
      MealsDataModel(lists: ["급식을 불러오는 중입니다"], cal: null, NTR: null);

  factory MealsDataModel.fromJson(Map<String, dynamic> json) => json == null
      ? empty
      : MealsDataModel(
          lists: (json["lists"] as String)?.split("<br/>"),
          cal: json["cal"],
          NTR: (json["NTR"] as String)?.split("<br/>"),
        );
}
