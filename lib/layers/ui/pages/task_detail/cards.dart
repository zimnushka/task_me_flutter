part of 'task_detail.dart';

class _StatusCard extends StatelessWidget {
  const _StatusCard(this.status);
  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 20, backgroundColor: status.color),
        const SizedBox(width: 10),
        Text(status.label),
      ],
    );
  }
}

class _UserButton extends StatelessWidget {
  const _UserButton(this.user);
  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundColor: Color(user.color)),
      title: Text(user.name),
      subtitle: Text(user.email),
    );
  }
}
