import 'package:flutter/cupertino.dart';
import 'routes_const.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final parts = routeSettings.name!.split('?');

    switch (parts[0]) {
      // case orderHistoryRoute:
      //   return CupertinoPageRoute(
      //     settings: routeSettings,
      //     builder: (_) => const OrderHistoryScreen()
      //   );
      //
      default:
        return CupertinoPageRoute(
          settings: routeSettings,
          builder: (_) => CupertinoPageScaffold(
            child: Center(
              child: Text(
                'Ошибка, роут для ${routeSettings.name} не найден',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
    }
  }
}
