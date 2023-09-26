import 'package:flutter/material.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';

class MultiSelectItem<T> {
  final bool isActive;
  final T value;
  final Widget child;

  const MultiSelectItem({
    required this.isActive,
    required this.value,
    required this.child,
  });

  MultiSelectItem<T> copyWith({
    bool? isActive,
    T? value,
    Widget? child,
  }) {
    return MultiSelectItem<T>(
      isActive: isActive ?? this.isActive,
      value: value ?? this.value,
      child: child ?? this.child,
    );
  }
}

class MultiSelector<T> extends StatefulWidget {
  const MultiSelector(
      {required this.onChange,
      required this.items,
      this.title = 'Select multiple items',
      super.key});
  final List<MultiSelectItem<T>> items;
  final String title;
  final Function(List<MultiSelectItem<T>>) onChange;

  @override
  State<MultiSelector<T>> createState() => _MultiSelectorState<T>();
}

class _MultiSelectorState<T> extends State<MultiSelector<T>> {
  late final newList = List.of(widget.items);

  void onTap(int index, MultiSelectItem<T> item) {
    newList[index] = item.copyWith(isActive: !item.isActive);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320, maxHeight: 500),
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: defaultPadding),
                Expanded(
                  child: ListView.builder(
                    itemCount: newList.length,
                    itemBuilder: (context, index) {
                      final item = newList[index];
                      return GestureDetector(
                        onTap: () => onTap(index, item),
                        child: Row(
                          children: [
                            Expanded(child: item.child),
                            if (item.isActive)
                              const Icon(
                                Icons.check_circle_outline_outlined,
                                color: Colors.green,
                              )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
                  onPressed: () => widget.onChange(newList),
                  child: const Text('Complete'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
