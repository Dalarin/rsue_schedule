import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rsue_schedule/blocs/schedule_bloc/schedule_bloc.dart';
import 'package:rsue_schedule/blocs/settings_bloc/settings_bloc.dart';
import 'package:rsue_schedule/screens/schedule_screen.dart';

class TeacherScreen extends StatelessWidget {
  final SettingsBloc bloc;

  const TeacherScreen(this.bloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScheduleBloc>(
      create: (context) {
        return ScheduleBloc()..add(GetTeachersForGroup(bloc.settings.group));
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Преподаватели'),
        ),
        body: SafeArea(
          child: BlocBuilder<ScheduleBloc, ScheduleState>(
            builder: _buildElementsDependsOnState,
          ),
        ),
      ),
    );
  }

  Widget _buildElementsDependsOnState(
    BuildContext context,
    ScheduleState state,
  ) {
    if (state is ScheduleLoading) {
      return _buildLoadingElement();
    } else if (state is ScheduleTeacherLoaded) {
      return _buildTeacherList(context, state.teachers);
    } else {
      return _buildTeacherList(context, []);
    }
  }

  Widget _buildLoadingElement() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildTeacherList(BuildContext context, List<String> teachers) {
    if (teachers.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, index) {
          String teacher = teachers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ScheduleScreen({'teacher': teacher});
                    },
                  ),
                );
              },
              title: Text(teacher),
            ),
          );
        },
        itemCount: teachers.length,
      );
    }
    return const Text('Отсутствует список преподавателей');
  }
}
