class AppRouter {
  String name;
  String path;
  AppRouter({
    required this.name,
    required this.path,
  });
}

class RutasNombres {
  static final AppRouter login = AppRouter(name: '/login', path: '/');
  static final AppRouter signUp = AppRouter(name: 'signup', path: 'signup');
  static final AppRouter inicio =
      AppRouter(name: '/home', path: '/home');
  static final AppRouter platformas =
      AppRouter(name: 'platformas', path: 'platformas');
  static final AppRouter clientes =
      AppRouter(name: 'clientes', path: 'clientes');
  static final AppRouter cuentas =
      AppRouter(name: 'cuentas', path: 'cuentas');
  static final AppRouter susbscripcion =
      AppRouter(name: 'subscripcion', path: 'subscripcion');
}
