import 'package:camilamuebleria/screens/home_screen.dart';
import 'package:camilamuebleria/screens/login_screen.dart';
import 'package:camilamuebleria/screens/register_screen.dart';
import 'package:camilamuebleria/screens/admin/view_products.dart';
import 'package:camilamuebleria/screens/admin/update_products.dart';
import 'package:camilamuebleria/screens/admin/insert_products.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = 'register';
  static const String home = 'home';
  static const String cocinasScreen = 'cocinas_screen';
  static const String productos = 'products';
  static const String view = 'view_data';
  static const String update = 'update_data';
  static const String insert = 'insert_data';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case view:
        return MaterialPageRoute(builder: (_) => const ViewProducts());
      case insert:
        return MaterialPageRoute(builder: (_) => const InsertProducts());
      case update:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => UpdateProducts(
            id: args['id'],
            image: args['image'],
            price: args['price'],
            description: args['description'],
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
