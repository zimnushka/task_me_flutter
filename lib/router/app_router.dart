import 'package:go_router/go_router.dart';

class AppRouter {
  final GoRouter _router;

  const AppRouter(this._router);

  Future<void> goTo(AppPage page) async {
    _router.pushNamed(
      page.name,
      params: page.params ?? {},
      queryParams: page.queryParams ?? {},
      extra: page.extra,
    );
  }

  Future<void> pop() async {
    if (_router.canPop()) {
      _router.pop();
    }
  }
}

abstract class AppPage {
  String get name;
  Map<String, String>? get params;
  Map<String, String>? get queryParams;
  Object? get extra;
}
