import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:rsue_schedule/models/schedule.dart';

class TeacherScheduleWidget extends StatelessWidget {
  final Schedule schedule;
  final int index;
  const TeacherScheduleWidget({Key? key, required this.schedule, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: Card(
          child: ListTile(
            title: Text(schedule.lesson),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(schedule.type),
                Text(schedule.group),
                Text('ауд. ${schedule.auditorium}'),
              ],
            ),
            trailing: Text(schedule.time),
          ),
        ),
      ),
    );
  }
}
