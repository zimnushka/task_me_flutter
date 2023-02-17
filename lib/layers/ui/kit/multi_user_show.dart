import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';

const _maxCount = 3;
const _positionFromLeftIndex = 1.2;

class MultiUserShow extends StatefulWidget {
  const MultiUserShow(this.users, {this.radius = 15, super.key});
  final List<User> users;
  final double radius;

  @override
  State<MultiUserShow> createState() => _MultiUserShowState();
}

class _MultiUserShowState extends State<MultiUserShow> {
  final List<Widget> usersWidget = [];
  List<User> usersOld = [];

  void updateWidgets() {
    usersWidget.clear();

    usersOld = List.of(widget.users);
    if (usersOld.length > _maxCount) {
      for (int i = 0; i < _maxCount; i++) {
        usersWidget.add(_UserCard(widget.radius, i, usersOld[i]));
      }
      usersWidget.add(Positioned(
          left: _maxCount * widget.radius + widget.radius,
          child: _Circle(widget.radius, Colors.grey, '+${widget.users.length - 3}')));
    } else {
      for (int i = 0; i < usersOld.length; i++) {
        usersWidget.add(_UserCard(widget.radius, i, usersOld[i]));
      }
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
      width: widget.radius * 2 +
          ((usersOld.length - 1) * widget.radius * _positionFromLeftIndex) +
          (usersOld.length > _maxCount
              ? ((widget.radius * _positionFromLeftIndex) - widget.radius) * 2
              : 0),
      height: widget.radius * 2,
      child: Stack(children: usersWidget.reversed.toList()),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard(this.radius, this.index, this.user);
  final double radius;
  final User user;
  final int index;

  @override
  Widget build(BuildContext context) => Positioned(
      left: index * (radius * _positionFromLeftIndex),
      child: _Circle(radius, Color(user.color), user.initials));
}

class _Circle extends StatelessWidget {
  const _Circle(this.radius, this.color, this.label);
  final Color color;
  final double radius;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(blurRadius: 0.1, spreadRadius: 0.01)],
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(child: Text(label, style: const TextStyle(color: Colors.white))),
    );
  }
}
