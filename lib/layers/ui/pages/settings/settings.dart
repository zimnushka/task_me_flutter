import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/app/service/router.dart';
import 'package:task_me_flutter/layers/bloc/app_provider.dart';
import 'package:task_me_flutter/layers/bloc/task/task_state.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/color_selector.dart';
import 'package:task_me_flutter/layers/ui/kit/overlays/user_editor.dart';
import 'package:task_me_flutter/layers/ui/pages/settings/theme_previev.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

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

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  late final AppProvider appProvider = context.watch<AppProvider>();

  @override
  Widget build(BuildContext context) {
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
                      onTap: () => AppRouter.dialog((context) => Center(
                            child: Card(
                              child: SizedBox(
                                  width: 320,
                                  height: 420,
                                  child: Padding(
                                      padding: const EdgeInsets.all(defaultPadding),
                                      child: ColorSelector(
                                        initColor: Theme.of(context).primaryColor,
                                        onSetColor: (value) {
                                          appProvider.setTheme(color: value);
                                          Navigator.pop(context);
                                        },
                                      ))),
                            ),
                          )),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => AppRouter.dialog((context) => const UserEditDialog()),
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
                              appProvider.state.user!.name,
                              weight: FontWeight.bold,
                            ),
                            AppText(
                              appProvider.state.user!.email,
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
                          onTap: () => appProvider.setTheme(isLightTheme: true),
                          theme: setPrimaryColor(lightTheme, appProvider.state.user!.color),
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        if (appProvider.state.config.isLightTheme)
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Icon(Icons.check_circle, color: Colors.green, size: 30),
                          )
                      ],
                    ),
                    Stack(
                      children: [
                        ThemePreview(
                          onTap: () => appProvider.setTheme(isLightTheme: false),
                          theme: setPrimaryColor(darkTheme, appProvider.state.user!.color),
                          height: double.infinity,
                          width: double.infinity,
                        ),
                        if (!appProvider.state.config.isLightTheme)
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
                      .map((e) => _TaskViewCard(
                            isActive: appProvider.state.config.taskView == e,
                            onTap: () => appProvider.changeTaskView(e),
                            state: e,
                          ))
                      .toList(),
                ),
              ),
              const _Divider(),
              const _Header(
                title: 'Logout',
                subTitle: 'When you logout all your cached data deleted from this device',
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error),
                  onPressed: appProvider.deleteToken,
                  child: const Text('logout')),
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
