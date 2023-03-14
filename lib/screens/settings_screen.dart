import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rsue_schedule/blocs/settings_bloc/settings_bloc.dart';
import 'package:rsue_schedule/screens/invite_screen.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsBloc bloc;

  const SettingsScreen(this.bloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: SafeArea(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeListTile(),
              _buildGroupListTile(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupListTile(BuildContext context) {
    return ListTile(
      title: const Text('Изменить группу'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InviteScreen(bloc),
          ),
        );
      },
    );
  }

  Widget _buildThemeListTile() {
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: bloc,
      builder: (context, state) {
        return ListTile(
          title: const Text('Тема'),
          trailing: DropdownButton<ThemeMode>(
            value: bloc.settings.themeMode,
            items: const [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text('Системная'),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text('Светлая'),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text('Темная'),
              ),
            ],
            onChanged: (themeMode) {
              if (themeMode != null) {
                bloc.add(ChangeSettings(themeMode, bloc.settings.group));
              }
            },
          ),
        );
      }
    );
  }
}
