import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_me_flutter/bloc/events/overlay_event.dart';
import 'package:task_me_flutter/ui/styles/themes.dart';

enum OverlayType {
  error,
  success,
  info,
  none;

  Color get color {
    switch (this) {
      case OverlayType.error:
        return Colors.deepOrangeAccent.shade400;
      case OverlayType.success:
        return const Color.fromARGB(255, 44, 186, 1);
      case OverlayType.info:
        return const Color.fromARGB(255, 2, 127, 190);
      case OverlayType.none:
        return Colors.transparent;
    }
  }

  Widget get icon {
    switch (this) {
      case OverlayType.error:
        return Icon(Icons.close, size: 20, color: color);
      case OverlayType.success:
        return Icon(Icons.done, size: 20, color: color);
      case OverlayType.info:
        return Icon(Icons.info_outline, size: 20, color: color);
      case OverlayType.none:
        return const SizedBox();
    }
  }
}

class OverlayManager {
  static OverlayEntry showOverlayMessage({
    required OverlayState overlayState,
    required OverlayEvent event,
    Duration duration = const Duration(seconds: 4),
  }) {
    OverlayEntry? overlayScreen;
    overlayScreen = OverlayEntry(builder: (context) {
      return _OverlayToast(
        onTap: () {
          overlayScreen?.remove();
        },
        event: event,
        duration: duration,
      );
    });
    overlayState.insert(overlayScreen);
    Future.delayed(duration).then(
      (value) {
        try {
          overlayScreen?.remove();
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      },
    );

    return overlayScreen;
  }
}

class _OverlayToast extends StatefulWidget {
  const _OverlayToast({
    required this.event,
    required this.duration,
    required this.onTap,
  });
  final OverlayEvent event;
  final Duration duration;
  final VoidCallback onTap;

  @override
  State<_OverlayToast> createState() => _OverlayToastState();
}

class _OverlayToastState extends State<_OverlayToast> {
  late final stream = Stream.periodic(const Duration(milliseconds: 10), (tic) {
    final curMillis = tic * 10;
    final totalMillis = widget.duration.inMilliseconds;
    return (curMillis / (totalMillis / 100)) / 100;
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: defaultPadding,
      right: defaultPadding,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Material(
          type: MaterialType.transparency,
          borderRadius: const BorderRadius.all(radius),
          elevation: 10,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(radius),
            child: ColoredBox(
              color: widget.event.type.color,
              child: SizedBox(
                width: 360,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DecoratedBox(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: widget.event.type.icon,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.event.message,
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<double>(
                        stream: stream,
                        builder: (context, snapshot) {
                          return LinearProgressIndicator(
                            minHeight: 5,
                            value: snapshot.data,
                            backgroundColor: Colors.white,
                            color: widget.event.type.color,
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
