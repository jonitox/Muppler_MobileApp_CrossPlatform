import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widgets/new_exercise.dart';

class ManageScreen extends StatefulWidget {
  static const routeName = '/manage_screen';
  final List<String> _exList;
  final Function deleteEx;
  final Function addEx;

  ManageScreen(this._exList, this.deleteEx, this.addEx);

  @override
  _ManageScreenState createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  List<String> _exList;

  @override
  void initState() {
    _exList = widget._exList ?? <String>[];
    super.initState();
  }

  void _tapAddNewEx() {
    showDialog(
      context: context,
      builder: (bctx) => NewExercise(_addNewEx),
      barrierDismissible: true,
    );
  }

  void _addNewEx(String ex) {
    setState(() {
      widget.addEx(ex);
    });
  }

  void _deleteEx(int idx) {
    setState(() {
      widget.deleteEx(idx, false);
    });
  }

  void _editEx(int idx) {
    setState(() {
      // ..
    });
  }

  Widget _buildExTile(int idx) {
    return Row(
      children: [
        Expanded(child: Text(_exList[idx])),
        IconButton(
          icon: Icon(Icons.edit_outlined),
          onPressed: () => _editEx(idx),
        ),
        IconButton(
          icon: Icon(Icons.delete_outlined),
          onPressed: () => _deleteEx(idx),
        ),
      ],
    );
  }

  void _popScreen() {
    // 안해도됨. 생성자자로 받은게 객체가 아니라 주소이므로.
    // if (_newExList != widget._oldExList) widget._updateExList(_newExList);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    print('build ManageScreen!');
    return Scaffold(
      appBar: AppBar(
        title: Text('내가 하는 운동 목록'),
        leading: FlatButton(
          child: Text('완료'),
          onPressed: _popScreen,
        ),
      ),
      body: _exList.length > 0
          ? ListView.builder(
              itemBuilder: (_, idx) => _buildExTile(idx),
              itemCount: _exList.length,
            )
          : Text('추가된 운동이 없습니다.'),
      floatingActionButton: FloatingActionButton(
        child: Text('추가하기'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: _tapAddNewEx,
        backgroundColor: Colors.blue,
      ),
    );
  }
}
