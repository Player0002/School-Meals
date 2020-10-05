import 'package:flutter/cupertino.dart';
import 'package:school_food/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Gender { MAN, WOMAN }
enum UserStatus { UPDATED, NO_UPDATED, UPDATING }

class UserProvider extends ChangeNotifier {
  int _age = 17;
  Gender gender = Gender.MAN;
  UserStatus _status = UserStatus.NO_UPDATED;
  UserStatus get status => _status;
  set status(val) {
    _status = val;
    notifyListeners();
  }

  int get age => _age;
  set age(val) {
    _age = val;
    notifyListeners();
  }

  UserProvider() {
    loadingData();
  }

  updateData({int age, Gender gender}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (age != null) {
      pref.setInt(kAge, age);
      this.age = age;
    }
    if (gender != null) {
      pref.setInt(kGender, gender == Gender.MAN ? 1 : 0);
      this.gender = gender;
    }
    notifyListeners();
  }

  loadingData() async {
    status = UserStatus.UPDATING;
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(kAge) && pref.containsKey(kGender)) {
      age = pref.get(kAge);

      gender = pref.getInt(kGender) == 1 ? Gender.MAN : Gender.WOMAN;
      status = UserStatus.UPDATED;
      return;
    }
    pref.setInt(kAge, 17);
    pref.setInt(kGender, 1);

    status = UserStatus.UPDATED;
  }
}
