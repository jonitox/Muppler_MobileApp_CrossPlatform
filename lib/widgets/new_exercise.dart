import 'package:flutter/material.dart';

class NewExercise extends StatefulWidget {
  final Function _addNewEx;
  NewExercise(this._addNewEx);
  @override
  _NewExerciseState createState() => _NewExerciseState();
}

class _NewExerciseState extends State<NewExercise> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text("운동의 이름"),
      content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: '이름을 입력하세요',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return '이름이 입력되지 않았습니다.';
                  }
                  return null;
                },
                onSaved: (name)=>widget._addNewEx(name),
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
                  child: Text('완료'),
                ),
              ),
            ],
          ),
        ),
    
      
    );
  }
}
