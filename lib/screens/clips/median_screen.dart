import 'dart:async';

import 'package:flutter/material.dart';
import 'package:t_hunt/screens/clips/create_clips.dart';

class MedianScreen extends StatefulWidget {
  const MedianScreen({super.key});

  @override
  State<MedianScreen> createState() => _MedianScreenState();
}

class _MedianScreenState extends State<MedianScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateClips(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Dialog(child: Text("Loading")),
      ),
    );
  }
}
