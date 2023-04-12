import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rsue_schedule/blocs/image_bloc/image_bloc.dart';
import 'package:rsue_schedule/blocs/settings_bloc/settings_bloc.dart';
import 'package:rsue_schedule/generated/l10n.dart';
import 'package:rsue_schedule/screens/invite_screen.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsBloc bloc;

  const SettingsScreen(this.bloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImageBloc>(
      create: (_) => ImageBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).settings),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<SettingsBloc, SettingsState>(
              listener: (context, state) {
                if (state is CachedDataDeleted) {
                  _showSnackBar(context, state.message);
                }
              },
            ),
            BlocListener<ImageBloc, ImageState>(
              listener: (context, state) {
                if (state is ImageAllowed) {
                  _showImageSourcePicker(context);
                }
              },
            )
          ],
          child: SafeArea(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildThemeListTile(),
                  _buildGroupListTile(context),
                  _buildClearCacheListTile(context),
                  HiddenContainer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImageSourcePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Выберите источник изображения:'),
              ListTile(
                onTap: () {
                  final bloc = context.read<ImageBloc>();
                  bloc.add(const PickImage(ImageSource.camera));
                },
                leading: const Icon(Icons.camera),
                title: const Text('Камера'),
              ),
              ListTile(
                onTap: () {
                  final bloc = context.read<ImageBloc>();
                  bloc.add(const PickImage(ImageSource.gallery));
                },
                leading: const Icon(Icons.photo),
                title: const Text('Галерея'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget _buildClearCacheListTile(BuildContext context) {
    return ListTile(
      title: Text(S.of(context).clearCache),
      onTap: () {
        bloc.add(const ClearCache());
      },
    );
  }

  Widget _buildGroupListTile(BuildContext context) {
    return ListTile(
      title: Text(S.of(context).changeGroup),
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
          onTap: () {
            final bloc = context.read<ImageBloc>();
            bloc.add(RequestImagePicking(bloc.counter++));
          },
          title: Text(S.of(context).theme),
          trailing: DropdownButton<ThemeMode>(
            value: bloc.settings.themeMode,
            items: [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text(S.of(context).system),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text(S.of(context).light),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text(S.of(context).dark),
              ),
            ],
            onChanged: (themeMode) {
              if (themeMode != null) {
                bloc.add(ChangeSettings(themeMode, bloc.settings.group));
              }
            },
          ),
        );
      },
    );
  }
}

class HiddenContainer extends StatefulWidget {
  const HiddenContainer({Key? key}) : super(key: key);

  @override
  State<HiddenContainer> createState() => _HiddenContainerState();
}

class _HiddenContainerState extends State<HiddenContainer> {
  double width = 300.0;
  double height = 300.0;
  Color color = Colors.red;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        if (state is ImageLoaded) {
          return Expanded(
            child: Column(
              children: [
                Image.file(
                  state.image,
                  width: 150,
                  height: 150,
                ),
                AnimatedContainer(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: color,
                  ),
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      width = Random().nextInt(300).toDouble();
                      height = Random().nextInt(300).toDouble();
                      color = Color.fromRGBO(
                        Random().nextInt(256),
                        Random().nextInt(256),
                        Random().nextInt(256),
                        1,
                      );
                    });
                  },
                  child: const Text('Анимировать'),
                ),
              ],
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
