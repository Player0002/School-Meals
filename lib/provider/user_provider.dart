import 'package:flutter/cupertino.dart';
import 'package:school_food/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Gender { MAN, WOMAN }
enum UserStatus { UPDATED, NO_UPDATED, UPDATING }
enum CustomTheme { LIGHT, DARK, SYSTEM }

class UserProvider extends ChangeNotifier {
  int _age = 17;
  bool _useMaterialDay = false;
  bool _useSwiperNextDay = false;
  CustomTheme _userTheme = CustomTheme.SYSTEM;

  Gender _gender = Gender.MAN;
  UserStatus _status = UserStatus.NO_UPDATED;
  UserStatus get status => _status;
  bool get useMaterialDay => _useMaterialDay;
  CustomTheme get userTheme => _userTheme;

  bool _useScroll = false;

  bool get useScroll => _useScroll;
  set useScroll(val) {
    _useScroll = val;
    notifyListeners();
  }

  set userTheme(theme) {
    _userTheme = theme;
    print(userThemeStr);
    notifyListeners();
  }

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
  int get userThemeInt => _userTheme == CustomTheme.SYSTEM
      ? 1
      : _userTheme == CustomTheme.LIGHT ? 2 : 3;
  String get userThemeStr => _userTheme == CustomTheme.SYSTEM
      ? "시스템"
      : _userTheme == CustomTheme.LIGHT ? "주간" : "야간";
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

    if (pref.getInt(kUserTheme) != userThemeInt) {
      pref.setInt(kUserTheme, userThemeInt);
    }
  }

  loadingData() async {
    status = UserStatus.UPDATING;
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(kAge) &&
        pref.containsKey(kGender) &&
        pref.containsKey(kUseSwiper) &&
        pref.containsKey(kUseMaterial) &&
        pref.containsKey(kUserTheme)) {
      _age = pref.get(kAge);
      _useSwiperNextDay = pref.getBool(kUseSwiper);
      _gender = pref.getInt(kGender) == 1 ? Gender.MAN : Gender.WOMAN;
      _useMaterialDay = pref.getBool(kUseMaterial);
      _userTheme = pref.getInt(kUserTheme) == 1
          ? CustomTheme.SYSTEM
          : pref.getInt(kUserTheme) == 2 ? CustomTheme.LIGHT : CustomTheme.DARK;
      status = UserStatus.UPDATED;
      return;
    }
    pref.setInt(kAge, 17);
    pref.setInt(kGender, 1);
    pref.setBool(kUseSwiper, false);
    pref.setInt(kUserTheme, 1);
    status = UserStatus.UPDATED;
  }
}
