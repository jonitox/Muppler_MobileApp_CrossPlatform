import 'package:flutter/material.dart';

class SetFilter extends StatefulWidget {
  final Map<String, bool> _filters;
  final List<String> _exList;
  SetFilter(this._filters, this._exList);
  @override
  _SetFilterState createState() => _SetFilterState();
}

class _SetFilterState extends State<SetFilter> {
  List<bool> _newFilters;

  @override
  void initState() {
    _newFilters = widget._exList.map((ex) => widget._filters[ex]).toList();
    _newFilters.add(widget._filters['undefined']);
    // _newFilters.add(widget._filters['undefined']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // scrollable: true,
      title: Text('캘린더에 표시할 운동을 지정하세요'),
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                child: Text('전체 선택'),
                onPressed: () => setState(() {
                  for (var i = 0; i < _newFilters.length; ++i) {
                    _newFilters[i] = true;
                  }
                }),
              ),
              RaisedButton(
                child: Text('전체 해제'),
                onPressed: () => setState(() {
                  for (var i = 0; i < _newFilters.length; ++i) {
                    _newFilters[i] = false;
                  }
                }),
              ),
            ],
          ),
          Expanded(
            child: Container(
              height: 50,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: _newFilters.length,
                // 코드가독성 증가: ListTile 빌더로뺴기.
                itemBuilder: (ctx, idx) => SwitchListTile(
                  title: Text(idx < widget._exList.length
                      ? widget._exList[idx]
                      : '등록되지않은 운동'),
                  value: _newFilters[idx],
                  onChanged: (value) => setState(() {
                    _newFilters[idx] = value;
                  }),
                ),
              ),
            ),
          ),
          RaisedButton(
              child: Text('저장하기'),
              color: Colors.blue,
              onPressed: () => Navigator.of(context).pop(_newFilters))
        ],
      ),
    );
  }
}
