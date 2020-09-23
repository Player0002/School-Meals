import 'package:flutter/material.dart';
import 'package:school_food/model/school_model.dart';
import 'package:school_food/services/search_school.dart';

enum SearchStatus {
  searching,
  end_searching,
  error_search,
  initialization,
  end_initialization,
  saving,
  end_saving,
}

class SearchProvider extends ChangeNotifier {
  final textController = TextEditingController();
  final scrollController = ScrollController();

  SearchStatus _status = SearchStatus.initialization;
  SearchStatus get status => _status;
  set status(val) {
    _status = val;
    notifyListeners();
  }

  SchoolModel searchModel = SchoolModel.empty;

  Future<void> search() async {
    String schoolName = textController.text;
    print(schoolName);
    try {
      status = SearchStatus.searching;
      final response = await findSchool(schoolName);
      if (response.status == 200) {
        searchModel = response;
        status = SearchStatus.end_searching;
        return;
      }
      searchModel = response;
      status = SearchStatus.error_search;
    } on Exception {
      status = SearchStatus.error_search;
    }
  }
}
