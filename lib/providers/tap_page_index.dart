import 'package:flutter/foundation.dart';

class TapPageIndex with ChangeNotifier {
  int _curIdx = 0;

  int get curIdx => _curIdx;

  void movePage(int idx) {
    _curIdx = idx;
    notifyListeners();
  }
}
