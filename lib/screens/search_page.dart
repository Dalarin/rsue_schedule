import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:rsue_schedule/blocs/schedule_bloc/schedule_bloc.dart';
import 'package:rsue_schedule/generated/l10n.dart';
import 'package:rsue_schedule/screens/schedule_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScheduleBloc>(
      create: (context) => ScheduleBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: SafeArea(
              child: _buildSearchPageBody(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchPageBody(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return _buildLoadingWidget();
        } else if (state is ScheduleTeacherLoaded) {
          return _buildListView(context, state.teachers);
        } else if (state is ScheduleError) {
          return _buildErrorWidget(context, state.message);
        } else {
          return _buildListView(context, []);
        }
      },
    );
  }

  Widget _buildListView(BuildContext context, List<String> teachers) {
    if (teachers.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ScheduleScreen({'teacher': teachers[index]}),
                ),
              );
            },
            title: Text(teachers[index]),
          );
        },
        itemCount: teachers.length,
      );
    }
    return _buildEmptyListWidget(context);
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Column(
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
            S.of(context).empty,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Поиск'),
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            autofocus: true,
            onSubmitted: (text) {
              final bloc = context.read<ScheduleBloc>();
              bloc.add(GetTeachersFromQuery(text));
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
