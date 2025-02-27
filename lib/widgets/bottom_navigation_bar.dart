import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_app/constants.dart';
import 'package:insta_app/cubits/switch_screen_cubit/switch_screen_cubit_states.dart';
import 'package:insta_app/cubits/switch_screen_cubit/switch_screens_cubit.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwitchScreensCubit, SwitchScreensStates>(
      builder: (context, state) {
        return CurvedNavigationBar(
          height: 68,
          key: bottomNavigationKey,
          index: BlocProvider.of<SwitchScreensCubit>(context).currentIndex,
          items: const <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Icon(FontAwesomeIcons.house, size: 24),
            ),
            Icon(FontAwesomeIcons.magnifyingGlass, size: 24),
            Icon(FontAwesomeIcons.facebookMessenger, size: 24),
            Icon(FontAwesomeIcons.plus, size: 24),
            Icon(FontAwesomeIcons.solidUser, size: 24),
          ],
          color: const Color.fromARGB(255, 29, 28, 28),
          buttonBackgroundColor:
              (state is SearchScreenState || state is AddPostScreenState)
                  ? kPink.shade700
                  : Colors.blue.shade900,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index) {
            BlocProvider.of<SwitchScreensCubit>(context).currentIndex = index;
            BlocProvider.of<SwitchScreensCubit>(context).getScreen();
          },
          letIndexChange: (index) => true,
        );
      },
    );
  }
}
