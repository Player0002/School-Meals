import 'package:flutter/material.dart';

class SwiperProvider extends ChangeNotifier {
  int _index = 0;
  int _previousIndex = 0;
  bool _isShowAll = false;
  SwiperProvider() {
    DateTime time = DateTime.now();
    if (time.hour < 8)
      _index = 0;
    else if (time.hour < 13)
      _index = 1;
    else if (time.hour < 23) _index = 2;
    _previousIndex = _index == 0 ? 2 : _index - 1;
  }
  set isShowAll(val) {
    _isShowAll = val;
    notifyListeners();
  }

  get isShowAll => _isShowAll;
  get previousIndex => _previousIndex;

  set index(val) {
    _previousIndex = _index;
    _index = val;
    notifyListeners();
  }

  get index => _index;
}
