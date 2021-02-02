import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';
import './choose_ex_screen.dart';

class AddEventScreen extends StatefulWidget {
  static const routeName = '/add_event_screen';
  final Function _routeChooseExScreen;
  final DateTime date;
  final List<String> _exList;
  AddEventScreen(this._routeChooseExScreen, this.date, this._exList);
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  String _selectedEx;
  Event _newEvent;
  final _weightController = TextEditingController();
  final _repController = TextEditingController();

  // initialize
  @override
  initState() {
    // final date = ModalRoute.of(context).settings.arguments as DateTime;
    _newEvent = Event(
      date: widget.date,
      id: DateTime.now().toString(),
    );
    super.initState();
  }

  // save Event // more: pop-up alert
  void _saveEvent() {
    if (_newEvent.sets.length == 0) {
      print('NO EVENT DESCRIBE!');
    } else if (_selectedEx == null) {
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
    setState(() {
      _newEvent.addSet(Set(
        double.parse(_weightController.text),
        int.parse(_repController.text),
      ));
    });
  }

  // tap Choose Exercise Button
  void _tapChooseEx() {
    widget._routeChooseExScreen(_selectedEx).then((ret) {
      if (ret != null && ret != _selectedEx) {
        setState(() {
          _selectedEx = ret;
        });
      } else if (!widget._exList.contains(_selectedEx)) {
        setState(() {
          _selectedEx = null;
        });
      }
    });
  }

  // build sets of Event
  List<Widget> get _buildSetList {
    int idx = 0;
    return _newEvent.sets.map((item) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('${++idx}세트'),
          Text('${item.weight}Kg'),
          Text('${item.rep}회'),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    print('build AddEventScreen!');
    return Scaffold(
      appBar: AppBar(
          title: Text('${DateFormat.Md().format(widget.date)}의 운동기록'),
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
              _selectedEx != null ? Text(_selectedEx) : Text('_unselected_'),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: _tapChooseEx,
              ),
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
