import 'package:flutter/material.dart';

class SwiperProvider extends ChangeNotifier {
  int _index = 0;
  int _previousIndex = 0;
  bool _isShowAll = false;

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
