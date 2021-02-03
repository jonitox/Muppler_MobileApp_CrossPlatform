import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';
import './choose_ex_screen.dart';

class AddEventScreen extends StatefulWidget {
  static const routeName = '/add_event_screen';
  final Function _routeChooseExScreen;
  final DateTime date;

  final Event oldEvent;
  AddEventScreen(
    this._routeChooseExScreen, {
    this.date,
    this.oldEvent,
  });
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  String _selectedEx;
  Event _newEvent;
  final _weightController = TextEditingController();
  final _repController = TextEditingController();
  final _exNameController = TextEditingController();
  // initialize
  @override
  initState() {
    // final date = ModalRoute.of(context).settings.arguments as DateTime;
    if (widget.oldEvent == null) {
      _newEvent = Event(
        date: widget.date,
        id: DateTime.now().toString(),
      );
    } else {
      _newEvent = widget.oldEvent;
      _selectedEx = _newEvent.exercise;
    }
    super.initState();
  }

  // save Event // more: pop-up alert
  void _saveEvent() {
    if (_selectedEx == null) {
      print('SELECTE EXERCISE!');
    } else {
      _newEvent.exercise = _selectedEx;

      print('Save Event!');
      print(_newEvent.exercise);
      Navigator.of(context).pop(_newEvent);
    }
  }

  // add a set to current Event
  void _addSet() {
    // more: 입력이 valid한지(double,int) 확인하는 logic추가
    setState(() {
      _newEvent.addSet(Set(
        double.parse(_weightController.text),
        int.parse(_repController.text),
      ));
    });
  }

  // remove a set from current Event
  void _removeSet() {
    setState(() {
      _newEvent.removeSet();
    });
  }

  // tap enter exercise button // more: subtract widget (다시 켰을떄 없게끔.)
  void _tapEnterEx() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('운동 이름'),
        content: TextField(
          controller: _exNameController,
          // onChanged: ,
        ),
        actions: [
          FlatButton(
            child: Text('취소'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          FlatButton(
            child: Text('저장'),
            onPressed: () => Navigator.of(ctx).pop(_exNameController.text),
          ),
        ],
      ),
      barrierDismissible: true,
    ).then((ret) {
      if (ret != null) {
        setState(() {
          _selectedEx = ret as String;
        });
      }
    });
  }

  // tap Choose my Exercise Button
  void _tapChooseEx() {
    widget._routeChooseExScreen(_selectedEx).then((ret) {
      if (ret != null && ret != _selectedEx) {
        setState(() {
          _selectedEx = ret;
        });
      }
    });
  }

  // tap Weight
  void _tapWeight(int idx) {
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("무게"),
        content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  if (double.tryParse(value) == null ||
                      double.parse(value) < 0) {
                    return 'unvalid input';
                  }
                  return null;
                },
                onSaved: (newWeight) => setState(() {
                  _newEvent.sets[idx].weight = double.parse(newWeight);
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('저장'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('취소'),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  // tap Rep
  void _tapRep(int idx) {
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("횟수"),
        content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return 'unvalid input';
                  }
                  return null;
                },
                onSaved: (newRep) => setState(() {
                  _newEvent.sets[idx].rep = int.parse(newRep);
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('저장'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('취소'),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

// // form없이 action으로 구현한 tap Rep // validation미포함
//   void _tapRep(int idx) {
//     String newValue;
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         content: Row(
//           children: [
//             Container(
//               width: 100, //?? size
//               child: TextField(
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) => newValue = val,
//               ),
//             ),
//             Text('회'),
//           ],
//         ),
//         actions: [
//           FlatButton(
//             child: Text('취소'),
//             onPressed: () => Navigator.of(ctx).pop(),
//           ),
//           FlatButton(
//             child: Text('저장'),
//             onPressed: () => Navigator.of(ctx).pop(newValue),
//           ),
//         ],
//       ),
//       barrierDismissible: true,
//     ).then((ret) {
//       if (ret != null) {
//         setState(() {
//           _newEvent.sets[idx].rep = int.parse(ret);
//         });
//       }
//     });
//   }
  // build set Tile of Event
  List<Widget> get _buildSetList {
    return _newEvent.sets.asMap().entries.map((entry) {
      final idx = entry.key;
      final item = entry.value;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('${idx + 1}세트'),
          FlatButton(
            child: Text('${item.weight}Kg'),
            onPressed: () => _tapWeight(idx),
          ),
          FlatButton(
            child: Text('${item.rep}회'),
            onPressed: () => _tapRep(idx),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    print('build AddEventScreen!');
    return Scaffold(
      appBar: AppBar(
          title: Text('${DateFormat.Md().format(_newEvent.date)}의 운동기록'),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveEvent,
            ),
          ]),
      body: Column(
        children: [
          // select exercise
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('종목:'),
              RaisedButton(
                child: _selectedEx != null
                    ? Text(_selectedEx)
                    : Text('운동 이름을 입력하세요'),
                onPressed: _tapEnterEx,
              ),
              RaisedButton(
                onPressed: _tapChooseEx,
                child: Text('내가 하는 운동에서 선택'),
              )
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                ..._buildSetList,
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: '무게'),
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Text('Kg'),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: '반복수'),
                        controller: _repController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Text('회'),
                    if (_newEvent.numOfSets > 0)
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: _removeSet,
                      ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addSet,
                    ),
                  ],
                ),
              ],
            ),
          ),
          RaisedButton(
            child: Text('저장하기'),
            onPressed: _saveEvent,
          ),
        ],
      ),
    );
  }
}
