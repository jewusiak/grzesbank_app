
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grzesbank_app/widgets/authd_views/AuthdHomeView.dart';
import 'package:grzesbank_app/widgets/unauthd_views/UnauthenticatedHomeView.dart';
import 'package:grzesbank_app/api/ApiService.dart';
import 'package:grzesbank_app/state/AppState.dart';
import 'package:grzesbank_app/widgets/nav/Drawers.dart';
import 'package:grzesbank_app/widgets/nav/SessionAppBar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
      ],
      child: MaterialApp(
        navigatorKey: NavigationContext.mainNavKey,
        title: 'Grzesbank',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return AppScaffold(title: Text("Grzesbank24"), drawer: DrawerProvider(),
        body: appState.isAuthenticated ? AuthdHomeView() : UnauthenticatedHomeView()   );
  }

  
}


