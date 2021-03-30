import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ************ set sheet  ************ //
class SetSheet extends StatefulWidget {
  final List<int> weightHolder;
  final List<int> repHolder;
  final int setNumber;
  final bool isOnlyRep;
  final Function updateSetInfoHolders;
  SetSheet({
    this.weightHolder,
    this.repHolder,
    this.setNumber,
    this.isOnlyRep,
    this.updateSetInfoHolders,
  });

  @override
  _SetSheetState createState() => _SetSheetState();
}

class _SetSheetState extends State<SetSheet> {
  List<FixedExtentScrollController>
      _scrollControllers; // scrollController for picker
  final nums = List.generate(
      10,
      (i) => FittedBox(
          fit: BoxFit.contain,
          child: Center(
              child: Text(
            '$i',
          )))).toList();

  // init State
  @override
  void initState() {
    _scrollControllers = List.generate(
      widget.isOnlyRep ? 3 : 7,
      (i) => FixedExtentScrollController(
        // set initial item of controller(for each picker)
        initialItem: widget.isOnlyRep
            ? widget.repHolder[i]
            : (i < 4 ? widget.weightHolder[i] : widget.repHolder[i - 4]),
      ),
    ).toList();
    super.initState();
  }

  // dispose
  @override
  void dispose() {
    _scrollControllers.forEach((sc) => sc.dispose());
    super.dispose();
  }

  // ************ build set dial for bottom sheet ************ //
  @override
  Widget build(BuildContext context) {
    final mediaData = MediaQuery.of(context);

    return Container(
      height: mediaData.size.height / 6,
      padding: EdgeInsets.only(bottom: mediaData.padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!widget.isOnlyRep) weightPickerRow(mediaData),
          SizedBox(width: mediaData.size.width / 25),
          repPickerRow(mediaData),
        ],
      ),
    );
  }

  // ************ digit picker ************ //
  Widget picker(MediaQueryData mediaData, int idx) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: mediaData.size.height / 40),
      width: mediaData.size.width / 10,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: CupertinoPicker(
        scrollController: _scrollControllers[idx],
        children: nums,
        itemExtent: mediaData.size.height / 20,
        looping: false,
        onSelectedItemChanged: (int x) {
          widget.updateSetInfoHolders(
              widget.isOnlyRep ? true : idx > 3, idx > 3 ? idx - 4 : idx, x);
        },
      ),
    );
  }

  // ************ weight pickers ************ //
  Widget weightPickerRow(MediaQueryData mediaData) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        picker(mediaData, 0),
        picker(mediaData, 1),
        picker(mediaData, 2),
        Text(
          '.',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        picker(mediaData, 3),
        Text(
          'kg',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ],
    );
  }

  // ************ repetition pickers ************ //
  Widget repPickerRow(MediaQueryData mediaData) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        picker(mediaData, widget.isOnlyRep ? 0 : 4),
        picker(mediaData, widget.isOnlyRep ? 1 : 5),
        picker(mediaData, widget.isOnlyRep ? 2 : 6),
        Text(
          '회',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ],
    );
  }
}
