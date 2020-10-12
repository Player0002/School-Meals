import 'package:flutter/cupertino.dart';
import 'package:school_food/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Gender { MAN, WOMAN }
enum UserStatus { UPDATED, NO_UPDATED, UPDATING }

class UserProvider extends ChangeNotifier {
  int _age = 17;
  int _height = 176;

  bool _useSwiperNextDay = false;

  Gender _gender = Gender.MAN;
  UserStatus _status = UserStatus.NO_UPDATED;
  UserStatus get status => _status;
  set status(val) {
    _status = val;
    notifyListeners();
  }

  Gender get gender => _gender;
  int get height => _height;
  int get age => _age;
  bool get useSwiperNextDay => _useSwiperNextDay;

  set useSwiperNextDay(val) {
    _useSwiperNextDay = val;
    notifyListeners();
  }

  set gender(val) {
    _gender = val;
    notifyListeners();
  }

  set age(val) {
    _age = val;
    notifyListeners();
  }

  set height(val) {
    _height = val;
    notifyListeners();
  }

  UserProvider() {
    loadingData();
  }

  saveData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (age != null) {
      pref.setInt(kAge, age);
    }
    if (gender != null) {
      pref.setInt(kGender, gender == Gender.MAN ? 1 : 0);
    }
    if (pref.getBool(kUseSwiper) != useSwiperNextDay) {
      pref.setBool(kUseSwiper, useSwiperNextDay);
    }
    if (height != null) {
      pref.setInt(kHeight, height);
    }
    notifyListeners();
  }

  loadingData() async {
    status = UserStatus.UPDATING;
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(kAge) &&
        pref.containsKey(kGender) &&
        pref.containsKey(kUseSwiper) &&
        pref.containsKey(kHeight)) {
      _age = pref.get(kAge);
      _useSwiperNextDay = pref.getBool(kUseSwiper);
      _gender = pref.getInt(kGender) == 1 ? Gender.MAN : Gender.WOMAN;
      _height = pref.getInt(kHeight);
      status = UserStatus.UPDATED;
      return;
    }
    pref.setInt(kAge, 17);
    pref.setInt(kGender, 1);
    pref.setBool(kUseSwiper, false);
    pref.setInt(kHeight, 176);
    status = UserStatus.UPDATED;
  }
}
