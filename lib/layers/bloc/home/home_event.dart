class HomeEvent {}

class Load extends HomeEvent {}

class OnTaskTap extends HomeEvent {
  final int id;
  OnTaskTap(this.id);
}

class OnHeaderButtonTap extends HomeEvent {}

class Refresh extends HomeEvent {
  final bool user;
  final bool tasks;

  Refresh({this.tasks = false, this.user = false});
}
