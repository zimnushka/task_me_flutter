import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:task_me_flutter/layers/ui/styles/text.dart';
import 'package:task_me_flutter/layers/ui/styles/themes.dart';

class AuthPoster extends StatefulWidget {
  const AuthPoster();

  @override
  State<AuthPoster> createState() => AuthPosterState();
}

class AuthPosterState extends State<AuthPoster> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppMainTitleText('TaskMe', color: Theme.of(context).primaryColor),
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
            _InfoCard(
              image: Image.asset('assets/screen/tasks.png'),
              title: 'Simple and fast interface',
              description: '''
Convenient division of tasks and users by projects, which are always in quick access in the side menu!

Convenient division of tasks into statuses by colors, and nothing more!
''',
            ),
            _InfoCard(
              image: Image.asset('assets/screen/analytics.png'),
              title: 'Analytics',
              description: ''' 
Convenient project setup and user analytics and project cost calculation
''',
            ),
            _InfoCard(
              image: Image.asset('assets/screen/info.png'),
              title: 'Details task information',
              description: ''' 
The task can be given to several users at once, and you can also track their work time using time intervals!

unfortunately this version does not have file storage, but you can put links to clouds inside the task description
''',
            ),
          ],
        ),
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
  const _InfoCard({required this.title, required this.image, this.description = ''});
  final String title;
  final String description;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 400,
        maxHeight: 700,
        minHeight: 700,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          AppTitleText(title),
          const SizedBox(height: 10),
          AppText(description),
          Expanded(child: image),
        ],
      ),
    );
  }
}
