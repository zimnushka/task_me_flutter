abstract class AppStorage<T> {
  String get storageKey;
  Future<T?> get();
  Future<bool> save(T data);
  Future<bool> delete();
}
