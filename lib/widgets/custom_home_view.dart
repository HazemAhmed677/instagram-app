import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_app/constants.dart';
import 'package:insta_app/helper/post_widget.dart';
import 'package:insta_app/helper/show_snack_bar_function.dart';
import 'package:insta_app/models/post_model.dart';
import 'package:insta_app/models/user_model.dart';
import 'package:insta_app/widgets/stories_bar.dart';

class CustomHomeView extends StatefulWidget {
  const CustomHomeView({
    super.key,
    required this.currentUser,
  });
  final UserModel currentUser;

  @override
  State<CustomHomeView> createState() => _CustomHomeViewState();
}

class _CustomHomeViewState extends State<CustomHomeView> {
  @override
  Widget build(BuildContext context) {
    double hight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(kPosts)
            .orderBy('date time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
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
                            title: const Text(
                              'Log out of you account?',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
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
                                    await signOut();
                                    Get.back();
                                  } catch (e) {
                                    getShowSnackBar(
                                        context, 'Oops, there something wrong');
                                    // print(e.toString());
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
                          await showDialog(
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
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 18,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: hight * 0.14,
                  child: StoriesBar(
                    currentUser: widget.currentUser,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 26,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 70.0),
                sliver: SliverList.builder(
                  itemCount: snapshot.data?.size ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomPostWidget(
                      currentUser: widget.currentUser,
                      postModel: PostModel.fromJson(
                        snapshot.data!.docs[index],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
