import 'package:flutter/material.dart';
import 'package:insta_app/constants.dart';

getShowSnackBar(BuildContext context, String content) {
  try {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 13,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        duration: const Duration(milliseconds: 9500),
        backgroundColor: kPink.shade500,
        content: Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: kWhite,
          ),
        ),
      ),
    );
  } catch (e) {}
}
