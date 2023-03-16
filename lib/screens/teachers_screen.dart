import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:rsue_schedule/blocs/schedule_bloc/schedule_bloc.dart';
import 'package:rsue_schedule/blocs/settings_bloc/settings_bloc.dart';
import 'package:rsue_schedule/generated/l10n.dart';
import 'package:rsue_schedule/screens/schedule_screen.dart';
import 'package:rsue_schedule/screens/search_page.dart';

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
          title: Text(S.of(context).teachers),
        ),
        body: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverFillRemaining(
              child: BlocBuilder<ScheduleBloc, ScheduleState>(
                builder: _buildElementsDependsOnState,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                readOnly: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SearchScreen(),
                    ),
                  );
                },
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            )
          ],
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
    } else if (state is ScheduleError) {
      return _buildErrorWidget(context, state.message);
    } else {
      return _buildLoadingElement();
    }
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.7,
            child: const RiveAnimation.asset(
              'assets/anims/error.riv',
            ),
          ),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingElement() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyListWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.8,
            child: const RiveAnimation.asset(
              'assets/anims/empty.riv',
            ),
          ),
          Text(
            S.of(context).noTeachers,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
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
    return _buildEmptyListWidget(context);
  }
}
