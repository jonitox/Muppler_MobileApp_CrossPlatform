import 'package:flutter/material.dart';

class MemoDialog extends StatefulWidget {
  String memo;
  MemoDialog(this.memo);
  @override
  _MemoDialogState createState() => _MemoDialogState();
}

class _MemoDialogState extends State<MemoDialog> {
  TextEditingController memoController; //
  String savedMemo;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    memoController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: widget.memo,
              onSaved: (value) => savedMemo = value,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    _formKey.currentState.save();
                    Navigator.of(context).pop(savedMemo);
                  },
                  child: Text('확인'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
