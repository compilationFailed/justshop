import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:justshop/providers/shoppinglistentry_provider.dart';
import 'package:justshop/screens/login_screen.dart';
import 'package:justshop/screens/shoppinglist_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Load environment variables
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShoppinglistProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Justshop', //App-Name
        // home entscheidet, welcher Screen beim Start gezeigt wird:
        home: FirebaseAuth.instance.currentUser == null
            ? LoginScreen()
            : ShoppinglistsOverviewScreen(),
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: Colors.lightBlue.shade400,
            secondary: Colors.lightBlueAccent.shade200,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.lightBlue.shade400,
            foregroundColor: Colors.white,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.lightBlueAccent.shade200,
          ),
        ),
      ),
    );
  }
}
