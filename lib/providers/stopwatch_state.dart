import 'dart:async';

import 'package:flutter/foundation.dart';

class StopWatchState with ChangeNotifier {
  bool _isRunning = false;
  Timer _timer;
  bool _isOnOverlay = false;
  Stopwatch st = Stopwatch();

  bool get isRunning => _isRunning;
  bool get isOn => st.elapsed.compareTo(Duration.zero) > 0;
  bool get isOnOverlay => _isOnOverlay;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void switchOverlay() {
    _isOnOverlay = !_isOnOverlay;
    notifyListeners();
  }

  void start() async {
    st.start();
    _isRunning = true;
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      notifyListeners();
    });
  }

  Map<String, String> get getTime {
    return {
      'min': (st.elapsed.inMinutes % 60).toString().padLeft(2, '0'),
      'sec': (st.elapsed.inSeconds % 60).toString().padLeft(2, '0'),
      'msec':
          ((st.elapsed.inMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0'),
    };
  }

  void pause() {
    st.stop();
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
    }

    notifyListeners();
  }

  void reset() {
    st.reset();
    _timer?.cancel();
    _timer = null;

    _isRunning = false;

    notifyListeners();
  }
}
