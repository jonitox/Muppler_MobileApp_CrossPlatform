import 'package:flutter/foundation.dart';

class TapPageIndex with ChangeNotifier {
  int _curIdx = 0;
  int _funcPageIdx = 0;
  int get curIdx => _curIdx;
  int get funcPageIdx => _funcPageIdx;
  void movePage(int idx) {
    _curIdx = idx;
    notifyListeners();
  }

  void moveFuncPage(int idx) {
    _funcPageIdx = idx;
    notifyListeners();
  }
}
