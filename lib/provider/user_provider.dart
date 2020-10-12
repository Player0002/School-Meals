import 'package:flutter/cupertino.dart';
import 'package:school_food/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Gender { MAN, WOMAN }
enum UserStatus { UPDATED, NO_UPDATED, UPDATING }

class UserProvider extends ChangeNotifier {
  int _age = 17;
  bool _useMaterialDay = false;
  bool _useSwiperNextDay = false;

  Gender _gender = Gender.MAN;
  UserStatus _status = UserStatus.NO_UPDATED;
  UserStatus get status => _status;
  bool get useMaterialDay => _useMaterialDay;

  set useMaterialDay(val) {
    _useMaterialDay = val;
    notifyListeners();
  }

  set status(val) {
    _status = val;
    notifyListeners();
  }

  Gender get gender => _gender;
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

    if (pref.getBool(kUseMaterial) != useMaterialDay) {
      pref.setBool(kUseMaterial, useMaterialDay);
    }
    notifyListeners();
  }

  loadingData() async {
    status = UserStatus.UPDATING;
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(kAge) &&
        pref.containsKey(kGender) &&
        pref.containsKey(kUseSwiper) &&
        pref.containsKey(kUseMaterial)) {
      _age = pref.get(kAge);
      _useSwiperNextDay = pref.getBool(kUseSwiper);
      _gender = pref.getInt(kGender) == 1 ? Gender.MAN : Gender.WOMAN;
      _useMaterialDay = pref.getBool(kUseMaterial);
      status = UserStatus.UPDATED;
      return;
    }
    pref.setInt(kAge, 17);
    pref.setInt(kGender, 1);
    pref.setBool(kUseSwiper, false);
    status = UserStatus.UPDATED;
  }
}
