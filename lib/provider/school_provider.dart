import 'package:flutter/material.dart';
import 'package:school_food/constants/constants.dart';
import 'package:school_food/model/school_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SchoolEnum {
  selecting,
  end_selecting,
  non_selecting,
}

class SchoolProvider extends ChangeNotifier {
  SchoolEnum _status = SchoolEnum.non_selecting;
  SchoolEnum get status => _status;
  set status(status) {
    _status = status;
    notifyListeners();
  }

  SchoolProvider() {
    loadingData();
  }
  SchoolDataModel selectedSchool = SchoolDataModel.empty;

  selectSchool(SchoolDataModel model) async {
    status = SchoolEnum.selecting;
    selectedSchool = model;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(kSchoolName, model.school_name);
    pref.setString(kScCode, model.sc_code);
    pref.setString(kAscCode, model.a_sc_code);
    pref.setString(kAddress, model.address);
    status = SchoolEnum.end_selecting;
  }

  Future<void> loadingData() async {
    status = SchoolEnum.selecting;
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool usable = pref.containsKey(kSchoolName) &&
        pref.containsKey(kAddress) &&
        pref.containsKey(kAscCode) &&
        pref.containsKey(kScCode);
    if (usable) {
      selectedSchool = SchoolDataModel(
          school_name: pref.getString(kSchoolName),
          address: pref.getString(kAddress),
          a_sc_code: pref.getString(kAscCode),
          sc_code: pref.getString(kScCode));
      status = SchoolEnum.end_selecting;
    } else
      status = SchoolEnum.non_selecting;
  }
}
