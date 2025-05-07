import 'package:flutter/material.dart';
import 'package:flutter_app/components.dart';
import 'package:flutter_app/screen/loginscreen.dart';
import 'package:flutter_app/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/screen/secondchance.dart';
import 'package:flutter_app/screen/wrongnotescreen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Components(),
        '/wronganswers' : (context) => const Wrongnotescreen(),
        '/sign-in': (context) => const Loginscreen(),
        '/profile': (context) => const ProfilePage(),
        '/secondchance': (context) => const Secondchance(),
      },
    );
  }
}
