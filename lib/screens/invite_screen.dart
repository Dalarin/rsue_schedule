import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rsue_schedule/blocs/settings_bloc/settings_bloc.dart';

class InviteScreen extends StatelessWidget {
  InviteScreen({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
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
    );
  }

  Widget _buildInviteText(BuildContext context) {
    return Text(
      'Добро пожаловать\nВведите ваш номер группы в формате ПРИ-311',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return FilledButton(
      onPressed: () {
        final bloc = context.read<SettingsBloc>();
        bloc.settings.group = _controller.text;
        bloc.add(ChangeSettings(bloc.settings));
      },
      child: const Text('Подтвердить'),
    );
  }
}
