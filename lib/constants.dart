import 'package:flutter/material.dart';

const kImage = 'assets/images/logo.jpg';
const kPink = Colors.pink;
const kPuple = Color.fromARGB(255, 198, 115, 221);
const kBlack = Colors.black;
const kWhite = Colors.white;
const kCollection = 'users';
const kImages = 'images';
const kPosts = 'posts';
const kPostsImages = 'posts_images';
Future<void> kAnimateTo(ScrollController controller) async {
  return await controller.animateTo(
    controller.position.maxScrollExtent,
    duration: const Duration(milliseconds: 100),
    curve: Curves.linear,
  );
}
