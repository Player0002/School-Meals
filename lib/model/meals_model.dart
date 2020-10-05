import 'package:equatable/equatable.dart';

class MealsModel {
  final MealsDataModel breakfast;
  final MealsDataModel lunch;
  final MealsDataModel dinner;

  static MealsModel empty = MealsModel(
      breakfast: MealsDataModel.empty,
      lunch: MealsDataModel.empty,
      dinner: MealsDataModel.empty);

  MealsModel({this.breakfast, this.lunch, this.dinner});
  bool get isNotEmpty =>
      breakfast != MealsDataModel.empty ||
      lunch != MealsDataModel.empty ||
      dinner != MealsDataModel.empty;
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

  factory MealsModel.fromJson(Map<String, dynamic> json) => MealsModel(
        breakfast: MealsDataModel.fromJson(json["breakfast"]),
        lunch: MealsDataModel.fromJson(json["lunch"]),
        dinner: MealsDataModel.fromJson(json["dinner"]),
      );
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

  factory MealsDataModel.fromJson(Map<String, dynamic> json) => json == null
      ? empty
      : MealsDataModel(
          lists: (json["lists"] as String)?.split("<br/>"),
          cal: json["cal"],
          NTR: (json["NTR"] as String)?.split("<br/>"),
        );
}
