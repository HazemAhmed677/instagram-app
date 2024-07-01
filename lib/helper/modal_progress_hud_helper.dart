import 'package:flutter/material.dart';
import 'package:insta_app/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ModalProgressHudHelper extends StatelessWidget {
  const ModalProgressHudHelper({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: const CircularProgressIndicator(
        color: kPink,
      ),
      blur: 1.5,
      color: kBlack,
      opacity: 0.3,
      inAsyncCall: true,
      child: child,
    );
  }
}
