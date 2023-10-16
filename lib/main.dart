import 'package:band_names_app/providers/socket_provider.dart';
import 'package:band_names_app/ui/pages/server_status_page.dart';
import 'package:flutter/material.dart';

import 'package:band_names_app/ui/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => SocketProvider())],
    child: const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Band Names App',
      initialRoute: HomePage.route,
      routes: {
        HomePage.route: (_) => const HomePage(),
        ServerStatusPage.route: (_) => const ServerStatusPage(),
      },
    );
  }
}
