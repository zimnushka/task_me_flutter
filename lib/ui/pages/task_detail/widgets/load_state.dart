part of '../task_detail.dart';

class _LoadState extends StatelessWidget {
  const _LoadState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadContainer(
                  height: 45,
                  width: 150,
                  lineColor: Theme.of(context).cardColor,
                  backGroundColor: Theme.of(context).cardColor.withOpacity(0.5),
                ),
                const SizedBox(height: 30),
                LoadContainer(
                  height: 50,
                  width: double.infinity,
                  lineColor: Theme.of(context).cardColor,
                  backGroundColor: Theme.of(context).cardColor.withOpacity(0.5),
                ),
                const SizedBox(height: 55),
                LoadContainer(
                  height: 500,
                  width: double.infinity,
                  lineColor: Theme.of(context).cardColor,
                  backGroundColor: Theme.of(context).cardColor.withOpacity(0.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: defaultPadding),
          LoadContainer(
            height: double.infinity,
            width: 350,
            lineColor: Theme.of(context).cardColor,
            backGroundColor: Theme.of(context).cardColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
