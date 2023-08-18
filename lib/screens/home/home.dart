import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:t_hunt/screens/clips/create_clips.dart';
import 'package:t_hunt/screens/clips/median_screen.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MedianScreen(),
                  )),
              child: Text("Create Clips"))
        ],
      )),
    );
  }
}
