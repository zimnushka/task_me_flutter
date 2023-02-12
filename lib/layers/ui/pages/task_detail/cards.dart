part of 'task_detail.dart';

class _StatusCard extends StatelessWidget {
  const _StatusCard(this.status);
  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: const BorderRadius.all(radius),
      ),
      height: 40,
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: Center(
        child: Text(
          status.label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _PopUpStatusCard extends StatelessWidget {
  const _PopUpStatusCard(this.status);
  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration:
              BoxDecoration(borderRadius: const BorderRadius.all(radius), color: status.color),
        ),
        const SizedBox(width: 10),
        Text(status.label),
      ],
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard(this.user);
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
