import 'package:get_it/get_it.dart';

class ServiceLocator {
  static final ServiceLocator _singleton = ServiceLocator._internal();

  static final GetIt _scopedInstance = GetIt.asNewInstance();

  ServiceLocator._internal();

  factory ServiceLocator() => _singleton;

  void registerService<T extends Object>(T service) {
    if (!_scopedInstance.isRegistered<T>()) {
      _scopedInstance.registerSingleton<T>(service);
    }
  }

  void registerLazySingleton<T extends Object>(T Function() factory) {
    if (!_scopedInstance.isRegistered<T>()) {
      _scopedInstance.registerLazySingleton<T>(factory);
    }
  }

  void registerFactory<T extends Object>(T Function() factory) {
    if (!_scopedInstance.isRegistered<T>()) {
      _scopedInstance.registerFactory<T>(factory);
    }
  }

  T getService<T extends Object>() {
    return _scopedInstance.get<T>();
  }

  void reset() {
    _scopedInstance.reset();
  }
}
