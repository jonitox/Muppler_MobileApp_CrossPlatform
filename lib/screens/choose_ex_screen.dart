import 'package:flutter/material.dart';

class ChooseExScreen extends StatefulWidget {
  final String _selectedEx;
  final List<String> _exList;
  final Function _routeManageScreen;
  ChooseExScreen(this._selectedEx, this._exList, this._routeManageScreen);

  @override
  _ChooseExScreenState createState() => _ChooseExScreenState();
}

class _ChooseExScreenState extends State<ChooseExScreen> {
  String _selectedEx;
  int _selectedIdx;
  List<String> _exList;
  @override
  void initState() {
    _selectedEx = widget._selectedEx;
    _exList = widget._exList ?? [];
    _selectedIdx = _exList.indexWhere((test) => test == _selectedEx);

    super.initState();
  }

  // build Exercises List
  Widget get _buildExList {
    return ListView.builder(
      itemBuilder: _buildExTile,
      itemCount: _exList.length,
    );
  }

  // build ListTile of exercise
  Widget _buildExTile(BuildContext ctx, int idx) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIdx = idx;
          _selectedEx = _exList[_selectedIdx];
        });
      },
      child: Container(
        color: _selectedIdx == idx ? Colors.amber[200] : Colors.white,
        child: ListTile(
          title: Text(_exList[idx]),
          trailing: _selectedIdx == idx ? Icon(Icons.check) : null,
        ),
      ),
    );
  }

  // save chosen Exercise
  void _saveChosenEx() {
    if (_selectedIdx == -1) {
      print('choose exercise!');
    } else {
      Navigator.of(context).pop(_selectedEx);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build ChooseExScreen!');
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Row(
              children: [
                Text('종목을 선택하세요'),
                RaisedButton(
                  child: Text('추가/관리'),
                  onPressed: () => widget._routeManageScreen().then((_) {
                    // 이 선언이 없으면 목록 갱신이 안됨. // 다른 방법은?
                    setState(() {
                      if (!widget._exList.contains(_selectedEx)) {
                        _selectedEx = null;
                        _selectedIdx = -1;
                      }
                    });
                  }),
                ),
              ],
            ),
            Expanded(child: _buildExList),
            RaisedButton(
              child: Text('선택완료'),
              onPressed: _saveChosenEx,
            ),
          ],
        ));
  }
}
