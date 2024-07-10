import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_app/constants.dart';
import 'package:insta_app/helper/profile_grid_view.dart';
import 'package:insta_app/helper/profile_helper.dart';
import 'package:insta_app/models/user_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
    this.userModel,
    this.currentUser,
    this.bar,
  });
  static String profileId = 'Search page';
  final UserModel? userModel;
  final UserModel? currentUser;
  final String? bar;
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    double hight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlack,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(kPosts)
                .where('userID', isEqualTo: widget.userModel!.uid)
                .snapshots(),
            builder: (context, snapshot1) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(kUsers)
                    .doc(widget.userModel!.uid)
                    .snapshots(),
                builder: (context, snapshot2) {
                  if (snapshot2.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: EdgeInsets.only(top: hight * 0.00005),
                      child: const Center(
                        child: Text('Loading',
                            style: TextStyle(
                              fontFamily: 'PlaywriteMX',
                            )),
                      ),
                    );
                  } else if (snapshot2.hasData) {
                    Map<String, dynamic> userMap =
                        snapshot2.data!.data() as Map<String, dynamic>;
                    UserModel userProfile = UserModel.fromJson(userMap);
                    return CustomScrollView(
                      physics: const BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast,
                      ),
                      slivers: [
                        SliverToBoxAdapter(
                            child: SizedBox(
                          height: 0.045 * hight,
                        )),
                        SliverToBoxAdapter(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: (widget
                                                .userModel!.profileImageURL !=
                                            null)
                                        ? CachedNetworkImageProvider(
                                            widget.userModel!.profileImageURL!)
                                        : const AssetImage(kNullImage),
                                    radius: 40,
                                  ),
                                  SizedBox(
                                    height: 0.01 * hight,
                                  ),
                                  Text(
                                    widget.userModel!.username,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              ProfileHelper(
                                number: snapshot1.data?.size.toString() ?? '0',
                                text: 'posts',
                              ),
                              ProfileHelper(
                                number:
                                    userProfile.followers!.length.toString(),
                                text: 'Followers',
                              ),
                              ProfileHelper(
                                number: widget.userModel!.following!.length
                                    .toString(),
                                text: 'Following',
                              ),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 0.02 * hight,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 0.055 * hight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    (currentUserID == widget.userModel!.uid)
                                        ? Colors.blue.shade800
                                        : (userProfile.followers!
                                                .contains(currentUserID))
                                            ? Colors.grey.shade900
                                            : kPink,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: (currentUserID ==
                                      widget.userModel!.uid)
                                  ? () {}
                                  : () async {
                                      Map<String, dynamic> searchedOne =
                                          snapshot2.data!.data()
                                              as Map<String, dynamic>;

                                      List followers = searchedOne['followers'];
                                      List following = searchedOne['following'];
                                      widget.userModel!.followers = followers;
                                      widget.currentUser!.following = following;
                                      if (followers.contains(currentUserID)) {
                                        await FirebaseFirestore.instance
                                            .collection(kUsers)
                                            .doc(widget.userModel!.uid)
                                            .update({
                                          'followers': FieldValue.arrayRemove(
                                              [currentUserID])
                                        });
                                        await FirebaseFirestore.instance
                                            .collection(kUsers)
                                            .doc(currentUserID)
                                            .update({
                                          'following': FieldValue.arrayRemove(
                                              [widget.userModel!.uid])
                                        });
                                        widget.userModel!.followers!
                                            .remove(currentUserID);
                                        widget.currentUser!.following!
                                            .remove(widget.userModel!.uid);
                                      } else {
                                        await FirebaseFirestore.instance
                                            .collection(kUsers)
                                            .doc(widget.userModel!.uid)
                                            .update({
                                          'followers': FieldValue.arrayUnion(
                                              [currentUserID])
                                        });
                                        await FirebaseFirestore.instance
                                            .collection(kUsers)
                                            .doc(currentUserID)
                                            .update({
                                          'following': FieldValue.arrayUnion(
                                              [widget.userModel!.uid])
                                        });
                                        widget.userModel!.followers!
                                            .add(currentUserID);
                                        widget.currentUser!.following!
                                            .add(widget.userModel!.uid);
                                      }
                                    },
                              child: Text(
                                (FirebaseAuth.instance.currentUser!.uid ==
                                        widget.userModel!.uid)
                                    ? 'Edit profile'
                                    : userProfile.followers!
                                            .contains(currentUserID)
                                        ? 'Unfollow'
                                        : 'Follow',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: kWhite,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 0.01 * hight,
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: Divider(
                            thickness: 2,
                            height: 2,
                            indent: 4,
                            endIndent: 4,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 0.01 * hight,
                          ),
                        ),
                        (snapshot1.connectionState == ConnectionState.waiting)
                            ? SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.only(top: hight * 0.28),
                                  child: const Center(
                                    child: Text(
                                      'Loading',
                                      style: TextStyle(
                                        fontFamily: 'PlaywriteMX',
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : (snapshot1.hasData)
                                ? ProfileGridView(
                                    posts: snapshot1.data,
                                  )
                                : const SliverToBoxAdapter(
                                    child: SizedBox(),
                                  ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
