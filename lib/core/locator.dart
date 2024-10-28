class Locator {
  static final Locator instance = Locator._internal();

  Locator._internal();

  factory Locator() {
    return instance;
  }

  final Map<Type, dynamic> _services = {};
  final Map<Type, Function> _lazyInitializers = {};

  void add<T>(Function() lazyService) {
    _lazyInitializers[T] = lazyService;
  }

  T get<T>() {
    if (_services.containsKey(T)) {
      return _services[T] as T;
    } else if (_lazyInitializers.containsKey(T)) {
      final lazyService = _lazyInitializers[T] as Function;
      _services[T] = lazyService();
      _lazyInitializers.remove(T);
      return _services[T] as T;
    }

    throw Exception('Service $T not found');
  }

  void override<T>(Function() lazyService) {
    if(_services.containsKey(T)) {
      _services.remove(T);
    }

    _lazyInitializers[T] = lazyService;
  }

  void clear() {
    _services.clear();
    _lazyInitializers.clear();
  }
}
