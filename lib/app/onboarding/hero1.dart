// ignore_for_file: library_private_types_in_public_api

import 'package:agora_care/app/onboarding/hero2.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimationApp extends StatefulWidget {
  const AnimationApp({Key? key}) : super(key: key);

  @override
  _AnimationAppState createState() => _AnimationAppState();
}

class _AnimationAppState extends State<AnimationApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          "Hero Animation",
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 60.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 500.0,
          child: Card(
            elevation: 2.0,
            child: InkWell(
              onTap: () {
                Get.to(
                  () => const DetialsScreen(),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Hero(
                        tag: "img",
                        child: Image.network(
                          "https://images.unsplash.com/photo-1552832230-c0197dd311b5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=986&q=80",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      "Rome Is a Beautiful Place",
                      style: TextStyle(
                        color: Color(0xFF1a1a1a),
                        fontSize: 24.0,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Text("hello world"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
