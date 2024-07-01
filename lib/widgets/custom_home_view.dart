import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_app/constants.dart';
import 'package:insta_app/helper/post_widget.dart';

class CustomHomeView extends StatefulWidget {
  const CustomHomeView({super.key});

  @override
  State<CustomHomeView> createState() => _CustomHomeViewState();
}

class _CustomHomeViewState extends State<CustomHomeView> {
  @override
  Widget build(BuildContext context) {
    double hight = MediaQuery.of(context).size.height;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Insta',
                style: TextStyle(
                  fontFamily: 'PlaywriteMX',
                  fontSize: 36,
                ),
              ),
              Tooltip(
                message: 'Log out',
                showDuration: const Duration(milliseconds: 500),
                child: IconButton(
                  onPressed: () async {
                    AlertDialog alert = AlertDialog(
                      backgroundColor: Colors.black,
                      shadowColor: Colors.grey.shade800,
                      title: const Text('Log out of you account?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: kWhite,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                              if (mounted) {
                                setState(() {
                                  Navigator.of(context)
                                    ..pop()
                                    ..pop();
                                });
                              }
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          child: const Text(
                            'Log out',
                            style: TextStyle(
                              color: kPink,
                            ),
                          ),
                        ),
                      ],
                    );
                    return await showDialog(
                      context: context,
                      builder: (context) => alert,
                    );
                  },
                  icon: const Icon(
                    Icons.logout,
                    size: 26,
                  ),
                ),
              )
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: hight * 0.18,
          ),
        ),
        SliverList.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return const CustomPostWidget();
          },
        ),
      ],
    );
  }
}
