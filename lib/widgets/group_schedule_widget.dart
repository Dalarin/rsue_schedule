import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';
import 'package:rsue_schedule/models/schedule.dart';
import 'package:rsue_schedule/screens/create_homework_screen.dart';

class GroupScheduleWidget extends StatelessWidget {
  final int index;
  final Schedule schedule;

  const GroupScheduleWidget(
      {Key? key, required this.schedule, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: Card(
          child: ListTile(
            onTap: () {
              _showScheduleFullDialog(context, schedule);
            },
            title: Text(schedule.lesson),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(schedule.type),
                Text(schedule.teacher),
                Text('ауд. ${schedule.auditorium}'),
              ],
            ),
            trailing: Flex(
              crossAxisAlignment: CrossAxisAlignment.end,
              direction: Axis.vertical,
              children: _buildTrailingListWidget(schedule),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTrailingListWidget(Schedule schedule) {
    List<Widget> widgets = [];
    widgets.add(Text(schedule.time));
    if (schedule.homework.isNotEmpty &&
        schedule.homework.any((homework) => !homework.isCompleted)) {
      widgets.addAll([
        const SizedBox(height: 5),
        const Icon(Icons.warning),
      ]);
    }
    return widgets;
  }

  void _showScheduleFullDialog(BuildContext context, Schedule schedule) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.only(
          top: 20,
          left: 10,
          right: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDescriptionSection(schedule, context),
            _buildHomeworkSection(context, schedule),
          ],
        ),
      ),
    );
  }

  Column _buildHomeworkSection(BuildContext context, Schedule schedule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Домашнее задание',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateHomeworkScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Добавить'),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _buildHomeworkListView(context, schedule),
      ],
    );
  }

  Widget _buildHomeworkListView(BuildContext context, Schedule schedule) {
    if (schedule.homework.isNotEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: ListView.builder(
          itemCount: schedule.homework.length,
          itemBuilder: (context, index) {
            final homework = schedule.homework[index];
            return ListTile(
              onTap: () {},
              title: Text(homework.title),
              subtitle: Text(
                homework.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              trailing: Text(
                DateFormat.yMMMd('ru').format(homework.dateTime),
              ),
            );
          },
        ),
      );
    }
    return _buildEmptyListWidget(context);
  }

  Widget _buildEmptyListWidget(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.7,
        child: const RiveAnimation.asset(
          'assets/anims/sleep.riv',
        ),
      ),
    );
  }

  Column _buildDescriptionSection(Schedule schedule, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          schedule.lesson,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          'Преподаватель: ${schedule.teacher}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          'Тип: ${schedule.type}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          'Аудитория: ${schedule.auditorium}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          'Время: ${schedule.time}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
