import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:rsue_schedule/blocs/schedule_bloc/schedule_bloc.dart';
import 'package:rsue_schedule/generated/l10n.dart';
import 'package:rsue_schedule/screens/schedule_screen.dart';

class AuditoriumScreen extends StatelessWidget {
  const AuditoriumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScheduleBloc>(
      create: (_) => ScheduleBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).auditories),
            ),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(context),
                  _buildAuditoriumScreenBody(context),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildElementsDependsOnState(
      BuildContext context, ScheduleState state) {
    if (state is ScheduleLoading) {
      return _buildLoadingWidget();
    } else if (state is ScheduleAuditoriumLoaded) {
      return _buildListView(context, state.auditorium);
    } else if (state is ScheduleError) {
      return _buildErrorWidget(context, state.message);
    }
    return _buildListView(context, []);
  }

  Widget _buildAuditoriumScreenBody(BuildContext context) {
    return SliverFillRemaining(
      child: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: _buildElementsDependsOnState,
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
                onSubmitted: (text) {
                  final bloc = context.read<ScheduleBloc>();
                  bloc.add(GetAuditoriumFromQuery(text));
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

  Widget _buildListView(BuildContext context, List<String> auditorium) {
    if (auditorium.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ScheduleScreen({'auditorium': auditorium[index]}),
                ),
              );
            },
            title: Text(auditorium[index]),
          );
        },
        itemCount: auditorium.length,
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
}
