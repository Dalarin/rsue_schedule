import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rsue_schedule/blocs/settings_bloc/settings_bloc.dart';
import 'package:rsue_schedule/generated/l10n.dart';
import 'package:rsue_schedule/widgets/bottom_nav_bar.dart';

class InviteScreen extends StatelessWidget {
  final SettingsBloc bloc;

  InviteScreen(this.bloc, {Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsError) {
              _showErrorSnackBar(context, state.message);
            } else if (state is SettingsLoaded) {
              _pushToMainScreen(context);
            }
          },
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildImage(context),
                  const SizedBox(height: 15),
                  _buildInviteText(context),
                  const SizedBox(height: 15),
                  _buildTextField(),
                  const SizedBox(height: 15),
                  _buildConfirmButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        width: double.infinity,
        child: Image.asset('assets/images/onboarding.png'),
      ),
    );
  }

  void _pushToMainScreen(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const BottomNavBar(),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget _buildInviteText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).inviteScreenTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
          S.of(context).welcomeText,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'ПРИ-331...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        onPressed: () {
          final bloc = context.read<SettingsBloc>();
          bloc.add(ChangeSettings(bloc.settings.themeMode, _controller.text));
        },
        child: Text(S.of(context).confirmButton),
      ),
    );
  }
}
