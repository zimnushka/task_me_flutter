// ignore_for_file: leading_newlines_in_multiline_strings

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_me_flutter/layers/bloc/auth.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

AuthCubit _bloc(BuildContext context) => BlocProvider.of(context);

class AuthPoster extends StatefulWidget {
  const AuthPoster();

  @override
  State<AuthPoster> createState() => AuthPosterState();
}

class AuthPosterState extends State<AuthPoster> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 800;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(defaultPadding * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppLabelTitleText(
                  'TaskMe',
                  color: Theme.of(context).primaryColor,
                  weight: FontWeight.bold,
                ),
                const AppMainTitleText('Open source task maneger'),
                const SizedBox(height: defaultPadding),
                const AppTitleText('Powered by'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: defaultPadding,
                  runSpacing: defaultPadding,
                  children: [
                    _ServiceCard(
                      icon: ClipRRect(
                        borderRadius: const BorderRadius.all(radius),
                        child: Image.asset('assets/icons/flutter.png'),
                      ),
                      label: 'Flutter',
                    ),
                    _ServiceCard(
                      icon: ClipRRect(
                        borderRadius: const BorderRadius.all(radius),
                        child: Image.asset('assets/icons/go.png'),
                      ),
                      label: 'GoLang',
                    ),
                    _ServiceCard(
                      icon: ClipRRect(
                        borderRadius: const BorderRadius.all(radius),
                        child: Image.asset('assets/icons/docker.png'),
                      ),
                      label: 'Docker',
                    ),
                  ],
                ),
                const SizedBox(height: defaultPadding),
                const SizedBox(height: defaultPadding),
                ElevatedButton(
                  onPressed: () => _bloc(context).setNewState(AuthPageState.login),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(300, 60)),
                  child: const AppTitleText(
                    'Try it now!',
                    weight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _InfoCard(
            textColor: lightTheme.textTheme.bodyMedium!.color!,
            axis: isMobile ? Axis.vertical : Axis.horizontal,
            backgroundColor: Theme.of(context).cardColor,
            image: Image.asset('assets/screen/tasks.png'),
            title: 'Simple and fast interface',
            description: '''
Convenient division of tasks and users by projects, which are always in quick access in the side menu!

Convenient division of tasks into statuses by colors, and nothing more!
''',
          ),
          _InfoCard(
            textColor: darkTheme.textTheme.bodyMedium!.color!,
            reverse: true,
            axis: isMobile ? Axis.vertical : Axis.horizontal,
            backgroundColor: Theme.of(context).primaryColor,
            image: Image.asset('assets/screen/analytics.png'),
            title: 'Analytics',
            description: ''' 
Convenient project setup and user analytics and project cost calculation
''',
          ),
          _InfoCard(
            textColor: lightTheme.textTheme.bodyMedium!.color!,
            axis: isMobile ? Axis.vertical : Axis.horizontal,
            backgroundColor: Theme.of(context).cardColor,
            image: Image.asset('assets/screen/info.png'),
            title: 'Details task information',
            description: ''' 
The task can be given to several users at once, and you can also track their work time using time intervals!

unfortunately this version does not have file storage, but you can put links to clouds inside the task description
''',
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.icon, required this.label});
  final String label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(radius),
        color: Theme.of(context).cardColor,
      ),
      padding: const EdgeInsets.all(10),
      height: 60,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [icon, const SizedBox(width: defaultPadding), AppText(label)],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.axis,
    required this.title,
    required this.image,
    required this.backgroundColor,
    required this.textColor,
    this.reverse = false,
    this.description = '',
  });
  final String title;
  final String description;
  final Widget image;
  final Axis axis;
  final Color backgroundColor;
  final Color textColor;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding * 2),
      color: backgroundColor,
      child: axis == Axis.vertical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                AppMainTitleText(
                  title,
                  color: textColor,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 10),
                AppText(
                  description,
                  color: textColor,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.all(radius),
                  child: image,
                ),
              ],
            )
          : AspectRatio(
              aspectRatio: 3 / 1,
              child: reverse
                  ? Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              AppMainTitleText(
                                title,
                                weight: FontWeight.bold,
                                color: textColor,
                              ),
                              const SizedBox(height: 10),
                              AppText(
                                description,
                                color: textColor,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: defaultPadding),
                        ClipRRect(
                          borderRadius: const BorderRadius.all(radius),
                          child: image,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(radius),
                          child: image,
                        ),
                        const SizedBox(width: defaultPadding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppMainTitleText(
                                title,
                                weight: FontWeight.bold,
                                color: textColor,
                              ),
                              const SizedBox(height: defaultPadding),
                              AppText(
                                description,
                                color: textColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}
