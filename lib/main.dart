import 'package:flutter/material.dart';
import 'package:loginscreen/views/login_animation.dart';

void main() {
  runApp(const chatapp());
}

class chatapp extends StatelessWidget {
  const chatapp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(),
    );
  }
}
