import 'package:flutter/material.dart';

class SwiperProvider extends ChangeNotifier {
  int _index = 0;
  bool _isShowAll = false;

  set isShowAll(val) {
    _isShowAll = val;
    notifyListeners();
  }

  get isShowAll => _isShowAll;

  set index(val) {
    _index = val;
    notifyListeners();
  }

  get index => _index;
}
