import 'package:flutter/material.dart';

// ************ memo dialog  ************ //
class MemoDialog extends StatefulWidget {
  final String memo;
  final String exerciseName;
  MemoDialog(this.exerciseName, this.memo);
  @override
  _MemoDialogState createState() => _MemoDialogState();
}

class _MemoDialogState extends State<MemoDialog> {
  String savedMemo;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final themeData = Theme.of(context);
    return AlertDialog(
      scrollable: true,
      // ************ memo title ************ //
      title: Container(
        width: deviceSize.width * 0.5,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: deviceSize.width * 0.3),
              child: Text(
                '${widget.exerciseName}',
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                strutStyle: StrutStyle(
                  height: 1,
                ),
                style: TextStyle(fontSize: 18, height: 1),
              ),
            ),
            const Text(
              '의 메모',
              softWrap: false,
              strutStyle: StrutStyle(
                height: 1,
              ),
              style: TextStyle(fontSize: 18, height: 1),
            ),
          ],
        ),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ************ memo box(text form field) ************ //
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black54),
                    borderRadius: BorderRadius.circular(10)),
                width: deviceSize.width * 0.8,
                child: TextFormField(
                  enableSuggestions: false,
                  autocorrect: false,
                  maxLines: 6,
                  autofocus: true,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: themeData.accentColor),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: themeData.accentColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: themeData.accentColor),
                    ),
                  ),
                  initialValue: widget.memo,
                  onSaved: (value) => savedMemo = value,
                ),
              ),
              // ************ completition buttons ************ //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: themeData.primaryColor),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: deviceSize.width * 0.2,
                      child: Center(
                        child: const Text(
                          '취소',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: themeData.primaryColor),
                    onPressed: () {
                      _formKey.currentState.save();
                      Navigator.of(context).pop(savedMemo);
                    },
                    child: Container(
                      width: deviceSize.width * 0.2,
                      child: Center(
                        child: const Text(
                          '저장',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
