import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/filters.dart';
import './exercise_list.dart';

// ************ filters dialog  ************ //
class FiltersDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final filters = Provider.of<Filters>(context, listen: false);

    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: FittedBox(
        child: const Text(
          '달력에 표시될 운동을 변경해보세요.',
          overflow: TextOverflow.visible,
          softWrap: true,
          maxLines: 2,
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
          const Divider(
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

  // ************ turn on/off all button ************ //
  Widget turnOnOffButton(BuildContext ctx, bool isOn, Filters filters) {
    return Container(
      width: MediaQuery.of(ctx).size.width * 0.25,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          elevation: 2,
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          side: BorderSide(color: Colors.grey, width: 0.8),
        ),
        onPressed: () {
          isOn ? filters.turnOnAll() : filters.turnOffAll();
        },
        child: Text(
          isOn ? '전부 선택' : '전부 취소',
          style: const TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
