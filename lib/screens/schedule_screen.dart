import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rsue_schedule/blocs/schedule_bloc/schedule_bloc.dart';
import 'package:rsue_schedule/models/schedule.dart';
import 'package:rsue_schedule/widgets/calendar_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:rsue_schedule/widgets/schedule_widget.dart';

class ScheduleScreen extends StatelessWidget {
  final Map<String, String> request;

  const ScheduleScreen(this.request, {Key? key}) : super(key: key);

  ScheduleEvent _formEvent(DateTime dateTime) {
    if (request.keys.contains('group')) {
      return GetScheduleForGroup(
        group: request['group']!,
        dateTime: dateTime,
      );
    } else if (request.keys.contains('teacher')) {
      return GetScheduleForTeacher(
        teacher: request['teacher']!,
        dateTime: dateTime,
      );
    } else {
      return GetScheduleForAuditorium(
        auditorium: request['auditorium']!,
        dateTime: dateTime,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScheduleBloc>(
      create: (context) {
        return ScheduleBloc()..add(_formEvent(DateTime.now()));
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Расписание ${request.values.first}'),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  _buildCalendar(context),
                  _buildBlocListBuilder(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return CalendarWidget(request);
  }

  Widget _buildBlocListBuilder(BuildContext context) {
    int currentIndex = 0;
    return Expanded(
      child: Dismissible(
        key: ValueKey(currentIndex),
        movementDuration: const Duration(milliseconds: 0),
        confirmDismiss: (dismiss) {
          final bloc = context.read<ScheduleBloc>();
          var duration = const Duration();
          if (dismiss == DismissDirection.endToStart) {
            duration = const Duration(days: 1);
          } else {
            duration = const Duration(days: -1);
          }
          if (bloc.state is ScheduleLoaded) {
            final date = (bloc.state as ScheduleLoaded).selectedDate.add(duration);
            bloc.add(_formEvent(date));
          }
          return Future.value(false);
        },
        child: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) {
            if (state is ScheduleLoaded) {
              return _buildAnimatedListView(context, state.schedule);
            } else if (state is ScheduleError) {
              return Text(state.message);
            } else if (state is ScheduleLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildAnimatedListView(context, []);
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedListView(BuildContext context, List<Schedule> schedule) {
    if (schedule.isNotEmpty) {
      return AnimationLimiter(
        child: ListView.builder(
          itemBuilder: (_, index) {
            return ScheduleWidget(schedule: schedule[index], index: index);
          },
          itemCount: schedule.length,
          shrinkWrap: true,
        ),
      );
    }

    return const Center(
      child: Text('Отсутствуют пары в данный день'),
    );
  }
}
