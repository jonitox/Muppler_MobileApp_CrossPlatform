import 'dart:async';

import 'package:flutter/foundation.dart';

class StopWatchState with ChangeNotifier {
  bool _isRunning = false;
  Timer _timer;
  bool _isOnOverlay = false;
  Stopwatch st = Stopwatch();
  List<String> _laptimes = [];

  bool get isRunning => _isRunning;
  bool get isOn => st.elapsed.compareTo(Duration.zero) > 0;
  bool get isOnOverlay => _isOnOverlay;

  List<String> get laptimes => [..._laptimes];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void switchOverlay() {
    _isOnOverlay = !_isOnOverlay;
  }

  void start() async {
    st.start();
    _isRunning = true;
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      notifyListeners();
    });
  }

  String get getTime {
    return (st.elapsed.inMinutes % 60).toString().padLeft(2, '0') +
        ':' +
        (st.elapsed.inSeconds % 60).toString().padLeft(2, '0') +
        ':' +
        ((st.elapsed.inMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0');
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
    _laptimes.clear();
    _isRunning = false;

    notifyListeners();
  }

  void addLap() {
    _laptimes.insert(
      0,
      getTime,
      // '${_sec ~/ 6000}'.padLeft(2, '0') +
      //     ':' +
      //     '${(_sec ~/ 100) % 60}'.padLeft(2, '0') +
      //     ':' +
      //     '${_sec % 100}'.padLeft(2, '0'),
    );
    notifyListeners();
  }
}
