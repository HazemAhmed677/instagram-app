import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:insta_app/constants.dart';
import 'package:insta_app/cubits/fetch_all_users_cubit/fetch_all_users_cubit.dart';
import 'package:insta_app/cubits/fetch_all_users_cubit/fetch_all_users_states.dart';
import 'package:insta_app/helper/person_in_search.dart';
import 'package:insta_app/models/user_model.dart';
import 'package:insta_app/services/fetch_and_push_searched_people_service.dart';
import 'package:insta_app/views/profile_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key, this.userModel});
  final UserModel? userModel;
  static String searchId = 'Search page';

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  QuerySnapshot<Map<String, dynamic>>? fetchedPersons;
  bool flag = false;
  bool flag2 = true;
  String bar = 'Follow';
  @override
  Widget build(BuildContext context) {
    double hight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String? input;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(kUsers)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: SizedBox(
              height: hight,
              child: Column(
                children: [
                  SizedBox(
                    height: hight * 0.02,
                  ),
                  // *******************************************
                  // text field
                  TextField(
                    onSubmitted: (value) async {
                      if (value != '') {
                        input = value;
                        flag = true;
                        try {
                          fetchedPersons =
                              await BlocProvider.of<FetchSearchedUsersCubit>(
                                      context)
                                  .fetchSearchedUsers(input!);
                          if (fetchedPersons!.docs.isNotEmpty) {
                            for (int i = 0;
                                i < fetchedPersons!.docs.length;
                                i++) {
                              await FetchAndPushSearchedPeopleService()
                                  .pushSerached(
                                currentUser: widget.userModel!,
                                searchedOne:
                                    UserModel.fromJson(fetchedPersons!.docs[i]),
                              );
                            }
                          }
                          setState(() {});
                        } catch (e) {
                          print(e.toString());
                        }
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(14),
                        ),
                        borderSide: BorderSide(
                          color: kWhite,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(14),
                        ),
                        borderSide: BorderSide(color: kPuple),
                      ),
                    ),
                    cursorColor: kPuple,
                  ),
                  SizedBox(
                    height: hight * 0.01,
                  ),
                  (snapshot.connectionState == ConnectionState.waiting)
                      ? Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: hight * 0.355),
                          child: const Center(
                              child: CircularProgressIndicator(
                            color: kPink,
                          )),
                        )
                      : (!flag && snapshot.hasData)
                          ? Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              padding: const EdgeInsets.only(
                                                  right: 14, left: 14),
                                              minimumSize: const Size(30, 30),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap),
                                          onPressed: () async {
                                            AlertDialog alert = AlertDialog(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 20, 20, 20),
                                              title: const Text(
                                                'Are you sure ?',
                                                style: TextStyle(
                                                  fontSize: 18,
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
                                                      Get.back();
                                                      await FetchAndPushSearchedPeopleService()
                                                          .removeSearchHistory(
                                                              currentUser: widget
                                                                  .userModel!);
                                                      setState(() {});
                                                    } catch (e) {
                                                      print(e.toString());
                                                    }
                                                  },
                                                  child: const Text(
                                                    'Delete',
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
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'Clear history',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                width: width * 0.01,
                                              ),
                                              const Icon(
                                                Icons.cancel_outlined,
                                                color: kPink,
                                                size: 20,
                                              )
                                            ],
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      clipBehavior: Clip.none,
                                      itemCount: widget.userModel!
                                              .serachedPeople?.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        return StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection(kUsers)
                                                .doc(
                                                  widget.userModel!
                                                          .serachedPeople![
                                                      index]['uid'],
                                                )
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 10.0,
                                                ),
                                                child: Dismissible(
                                                  key: UniqueKey(),
                                                  direction: DismissDirection
                                                      .endToStart,
                                                  onDismissed: (direction) {},
                                                  child: SizedBox(
                                                    height: hight * 0.08,
                                                    child: InkWell(
                                                      // highlightColor: kBlack,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              21),
                                                      radius: 16,
                                                      onTap: () {
                                                        Map<String, dynamic>
                                                            userMap = snapshot
                                                                    .data!
                                                                    .data()
                                                                as Map<String,
                                                                    dynamic>;
                                                        UserModel user =
                                                            UserModel.fromJson(
                                                                userMap);
                                                        Get.to(
                                                            ProfileView(
                                                              userModel: user,
                                                              currentUser: widget
                                                                  .userModel!,
                                                            ),
                                                            curve: Curves
                                                                .easeInOutQuint);
                                                      },
                                                      child: PersonInSearch(
                                                        username: widget
                                                                .userModel!
                                                                .serachedPeople![
                                                            index]['username'],
                                                        imageURL: widget
                                                                .userModel!
                                                                .serachedPeople![
                                                            index]['profile image'],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : BlocBuilder<FetchSearchedUsersCubit,
                              FetchSearchedUsersStates>(
                              builder: (context, state) {
                                if ((state is SucceedState)) {
                                  return (fetchedPersons?.docs.isEmpty ?? false)
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              top: hight * 0.38),
                                          child: const Center(
                                            child: Text(
                                              'user not found',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Expanded(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: hight * 0.015,
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount: fetchedPersons
                                                          ?.docs.length ??
                                                      0,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        bottom: 10.0,
                                                      ),
                                                      child: Dismissible(
                                                        key: UniqueKey(),
                                                        direction:
                                                            DismissDirection
                                                                .endToStart,
                                                        onDismissed:
                                                            (direction) {},
                                                        child: SizedBox(
                                                          height: hight * 0.08,
                                                          child: InkWell(
                                                            highlightColor:
                                                                kBlack,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        21),
                                                            radius: 16,
                                                            onTap: () async {
                                                              Get.to(
                                                                  () =>
                                                                      ProfileView(
                                                                        userModel:
                                                                            UserModel.fromJson(
                                                                          fetchedPersons!
                                                                              .docs[index],
                                                                        ),
                                                                        currentUser:
                                                                            widget.userModel!,
                                                                      ),
                                                                  curve: Curves
                                                                      .easeIn);
                                                            },
                                                            child:
                                                                PersonInSearch(
                                                              username: fetchedPersons!
                                                                          .docs[
                                                                      index]
                                                                  ['username'],
                                                              imageURL: fetchedPersons!
                                                                          .docs[
                                                                      index][
                                                                  'profileImageURL'],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                } else {
                                  return (state is FailuireState)
                                      ? const Center(
                                          child: Text(
                                              'oops, there somthing wrong'),
                                        )
                                      : const SizedBox();
                                }
                              },
                            ),
                ],
              ),
            ),
          );
        });
  }
}
