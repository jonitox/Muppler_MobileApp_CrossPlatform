import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/filters.dart';
import './exercise_list.dart';

class FiltersDialog extends StatelessWidget {
  // ************ turn on/off all button ************ //
  Widget turnOnOffButton(BuildContext ctx, bool isOn, Filters filters) {
    return Container(
      width: MediaQuery.of(ctx).size.width * 0.25,
      child: OutlinedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith<double>((_) => 2),
          backgroundColor:
              MaterialStateProperty.resolveWith<Color>((_) => Colors.white),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) =>
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          side: MaterialStateProperty.resolveWith<BorderSide>(
            (_) => BorderSide(color: Colors.grey, width: 0.8),
          ),
        ),
        onPressed: () {
          isOn ? filters.turnOnAll() : filters.turnOffAll();
        },
        child: Text(
          isOn ? '전부 선택' : '전부 취소',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  // ************ builld filters dialog  ************ //
  @override
  Widget build(BuildContext context) {
    final filters = Provider.of<Filters>(context, listen: false);

    return AlertDialog(
      scrollable: true, //
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

      title: FittedBox(
        child: Text(
          '달력에 표시할 운동을 변경해보세요.',
          overflow: TextOverflow.visible,
        ),
      ),

      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                turnOnOffButton(context, true, filters),
                turnOnOffButton(context, false, filters),
              ],
            ),
          ),
          Divider(
            height: 2,
            color: Colors.grey,
            thickness: 1,
          ),
          ExerciseList(
            isForFilters: true,
          ),
        ],
      ),
    );
  }
}
