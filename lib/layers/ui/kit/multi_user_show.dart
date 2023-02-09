import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

class MultiUserShow extends StatefulWidget {
  const MultiUserShow(this.users, {this.radius = 15, this.width = 100, super.key});
  final List<User> users;
  final double radius;
  final double width;

  @override
  State<MultiUserShow> createState() => _MultiUserShowState();
}

class _MultiUserShowState extends State<MultiUserShow> {
  final List<Widget> usersWidget = [];
  List<User> usersOld = [];

  void updateWidgets() {
    usersWidget.clear();

    usersOld = List.of(widget.users);
    if (usersOld.length > 3) {
      usersWidget.addAll(usersOld
          .getRange(0, 3)
          .toList()
          .asMap()
          .entries
          .map((entry) => _UserCard(widget.radius, entry.key, entry.value))
          .toList()
          .reversed
          .toList());
    } else {
      usersWidget.addAll(usersOld
          .asMap()
          .entries
          .map((entry) => _UserCard(widget.radius, entry.key, entry.value))
          .toList()
          .reversed
          .toList());
    }
    setState(() {});
  }

  @override
  void initState() {
    updateWidgets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!listEquals(widget.users, usersOld)) {
      updateWidgets();
    }
    return SizedBox(
      width: widget.width,
      height: widget.radius * 2,
      child: Row(
        children: [
          Expanded(child: Stack(children: usersWidget)),
          if (widget.users.length > 3) Text('+${widget.users.length - 3}')
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard(this.radius, this.index, this.user);
  final double radius;
  final User user;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: index * radius,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          boxShadow: const [BoxShadow(blurRadius: 0.1, spreadRadius: 0.01)],
          color: Color(user.color),
          shape: BoxShape.circle,
        ),
        child: Center(child: Text(user.initials, style: const TextStyle(color: Colors.white))),
      ),
    );
  }
}
