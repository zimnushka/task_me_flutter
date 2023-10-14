import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/bloc/events/edit_user_event.dart';
import 'package:task_me_flutter/bloc/events/logout_event.dart';
import 'package:task_me_flutter/bloc/events/set_config_event.dart';
import 'package:task_me_flutter/bloc/main_bloc.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/router/app_router.dart';
import 'package:task_me_flutter/ui/pages/settings/theme_previev.dart';
import 'package:task_me_flutter/ui/styles/text.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';
import 'package:task_me_flutter/ui/widgets/overlays/color_selector.dart';
import 'package:task_me_flutter/ui/widgets/overlays/user_editor.dart';

class SettingsRoute implements AppPage {
  const SettingsRoute();

  @override
  String get name => 'settings';

  @override
  Map<String, String>? get params => null;

  @override
  Map<String, String>? get queryParams => null;
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static AppPage route() => const SettingsRoute();

  @override
  Widget build(BuildContext context) {
    return const _Body();
  }
}

class _Body extends StatelessWidget {
  const _Body();

  Future<void> editUserColor(BuildContext context, Color color, User user) async {
    final newUser = user.copyWith(colorInt: color.value);
    context.read<MainBloc>().add(EditUserEvent(user: newUser));
  }

  Future<void> editTheme(BuildContext context, bool isLightTheme) async {
    final vm = context.read<MainBloc>();
    vm.add(SetConfigEvent(vm.state.config.copyWith(isLightTheme: isLightTheme)));
  }

  Future<void> editTaskView(BuildContext context, TaskViewState state) async {
    final vm = context.read<MainBloc>();
    vm.add(SetConfigEvent(vm.state.config.copyWith(taskView: state)));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<MainBloc>();
    final user = context.select((MainBloc vm) => vm.state.authState.user!);
    final config = context.select((MainBloc vm) => vm.state.config);

    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(radius),
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButton(),
                  AppMainTitleText('Settings'),
                ],
              ),
              const SizedBox(height: defaultPadding * 2),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: GridView.count(
                  primary: true,
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 1,
                  children: [
                    const _Header(
                      title: 'User color',
                      subTitle: 'Your avatar color, and active theme color',
                    ),
                    const _Header(
                      title: 'User info',
                      subTitle: 'Email, name, cost',
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Center(
                            child: Card(
                              child: SizedBox(
                                width: 320,
                                height: 420,
                                child: Padding(
                                  padding: const EdgeInsets.all(defaultPadding),
                                  child: ColorSelector(
                                    initColor: Theme.of(context).primaryColor,
                                    onSetColor: (value) {
                                      editUserColor(context, value, user);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const UserEditDialog(),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(radius),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText(
                              user.name,
                              weight: FontWeight.bold,
                            ),
                            AppText(
                              user.email,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const _Divider(),
              const _Header(
                title: 'Theme',
                subTitle: 'Your theme only for this device',
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: GridView.count(
                  primary: true,
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: [
                    Stack(
                      children: [
                        ThemePreview(
                          onTap: () => editTheme(context, true),
                          theme: setPrimaryColor(lightTheme, user.color),
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        if (config.isLightTheme)
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Icon(Icons.check_circle, color: Colors.green, size: 30),
                          )
                      ],
                    ),
                    Stack(
                      children: [
                        ThemePreview(
                          onTap: () => editTheme(context, false),
                          theme: setPrimaryColor(darkTheme, user.color),
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        if (!config.isLightTheme)
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Icon(Icons.check_circle, color: Colors.green, size: 30),
                          )
                      ],
                    ),
                  ],
                ),
              ),
              const _Divider(),
              const _Header(
                title: 'Task view',
                subTitle: 'Default task view',
              ),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  children: TaskViewState.values
                      .map(
                        (e) => _TaskViewCard(
                          isActive: config.taskView == e,
                          onTap: () => editTaskView(context, e),
                          state: e,
                        ),
                      )
                      .toList(),
                ),
              ),
              const _Divider(),
              const _Header(
                title: 'Logout',
                subTitle: 'When you logout all your cached data deleted from this device',
              ),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                onPressed: () => vm.add(LogoutEvent()),
                child: const Text('logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subTitle,
  });
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTitleText(title),
        const SizedBox(height: 5),
        AppText(subTitle),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: defaultPadding),
        Divider(),
        SizedBox(height: defaultPadding),
      ],
    );
  }
}

class _TaskViewCard extends StatelessWidget {
  const _TaskViewCard({
    required this.isActive,
    required this.onTap,
    required this.state,
  });
  final bool isActive;
  final TaskViewState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10, bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(radius),
              color: Theme.of(context).colorScheme.background,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  state.icon,
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                AppText(
                  state.label,
                  weight: FontWeight.bold,
                ),
              ],
            ),
          ),
          if (isActive)
            const Positioned(
                top: 0,
                left: 0,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ))
        ],
      ),
    );
  }
}
