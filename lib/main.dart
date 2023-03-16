import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rsue_schedule/blocs/settings_bloc/settings_bloc.dart';
import 'package:rsue_schedule/screens/invite_screen.dart';
import 'package:rsue_schedule/themes/themes.dart';
import 'package:rsue_schedule/widgets/bottom_nav_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildApplication(context);
  }

  Widget _buildApplication(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc(),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (prevState, newState) {
          return newState is! SettingsError;
        },
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SettingsLoaded) {
            return MaterialApp(
              onGenerateTitle: (context) => S.of(context).schedule,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: state.settings.themeMode,
              supportedLocales: S.delegate.supportedLocales,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: Builder(
                builder: (context) {
                  if (state.settings.group.trim().isNotEmpty) {
                    return const BottomNavBar();
                  }
                  return InviteScreen(context.read<SettingsBloc>());
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
