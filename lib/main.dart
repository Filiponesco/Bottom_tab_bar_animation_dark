import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tab_bar_animation_dark/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tab bar animation dark',
      theme: ThemeData(
        primaryColor: AppColors.blueColor,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  MenuItems _selectedMenuItem = MenuItems.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomBottomBar(
            selectedMenu: _selectedMenuItem,
            onTap: (menuItem) {
              setState(() {
                _selectedMenuItem = menuItem;
              });
            },
          ),
          PositionOfFab(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8, tileMode: TileMode.decal),
              child: FakeFab(),
            ),
          ),
          PositionOfFab(
            child: Fab(onTap: (menuItem){
              setState(() {
                _selectedMenuItem = menuItem;
              });
            },),
          ),
          PositionOfIndicator(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 20, tileMode: TileMode.decal),
              child: Indicator(),
            ),
            selectedItem: _selectedMenuItem,
          ),
          PositionOfIndicator(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 20, tileMode: TileMode.decal),
              child: Indicator(),
            ),
            selectedItem: _selectedMenuItem,
          ),
          PositionOfIndicator(
            child: Indicator(),
            selectedItem: _selectedMenuItem,
          ),
          PositionOfIndicator(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 20, tileMode: TileMode.decal),
              child: Indicator(
                opacity: .3,
              ),
            ),
            selectedItem: _selectedMenuItem,
          ),
        ],
      ),
    );
  }
}

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({Key? key, required this.onTap, required this.selectedMenu}) : super(key: key);
  final Function(MenuItems) onTap;
  final MenuItems selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 10.0,
          child: SvgPicture.asset(
            'assets/bottom_bar.svg',
            width: MediaQuery.of(context).size.width,
            color: AppColors.greyColor,
          ),
        ),
        Positioned(
            bottom: 40.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: SingleItem(
                  text: 'Home',
                  onTap: onTap,
                  menuItem: MenuItems.home,
                  isSelected: selectedMenu == MenuItems.home,
                )),
                Expanded(
                    child: SingleItem(
                  text: 'Wallet',
                  onTap: onTap,
                  menuItem: MenuItems.wallet,
                  isSelected: selectedMenu == MenuItems.wallet,
                )),
                SingleItem(
                  containsLogo: false,
                  text: 'Exchange',
                  onTap: onTap,
                  menuItem: MenuItems.exchange,
                  isSelected: selectedMenu == MenuItems.exchange,
                ),
                Expanded(
                    child: SingleItem(
                  text: 'Markets',
                  onTap: onTap,
                  menuItem: MenuItems.markets,
                  isSelected: selectedMenu == MenuItems.markets,
                )),
                Expanded(
                    child: SingleItem(
                  text: 'Profile',
                  onTap: onTap,
                  menuItem: MenuItems.profile,
                  isSelected: selectedMenu == MenuItems.profile,
                )),
              ],
            ))
      ],
    );
  }
}

class SingleItem extends StatefulWidget {
  const SingleItem({
    Key? key,
    this.isSelected = false,
    this.containsLogo = true,
    required this.text,
    required this.onTap,
    required this.menuItem,
  }) : super(key: key);
  final bool isSelected;
  final bool containsLogo;
  final String text;
  final Function(
    MenuItems,
  ) onTap;
  final MenuItems menuItem;

  @override
  State<SingleItem> createState() => _SingleItemState();
}

class _SingleItemState extends State<SingleItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        if(_controller.isCompleted){
          _controller.reverse();
        } else{
          _controller.forward();
        }

        widget.onTap(widget.menuItem);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.containsLogo
              ? AnimatedIcon(
                  color: widget.isSelected ? Colors.white : Colors.grey,
                  size: 30,
                  icon: widget.menuItem.icon,
                  progress: _controller,
                )
              : SizedBox(
                  height: 30.0,
                ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              widget.text,
              style: widget.isSelected ? TextStyle(color: Colors.white) : TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FakeFab extends StatelessWidget {
  const FakeFab({
    Key? key,
    this.opacity = .8,
  }) : super(key: key);
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(shape: CircleBorder(), color: AppColors.blueColor.withOpacity(opacity)),
      width: 70.0,
      height: 70.0,
    );
  }
}

class Fab extends StatelessWidget {
  const Fab({
    Key? key, required this.onTap,
  }) : super(key: key);
  final Function(MenuItems) onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => onTap(MenuItems.exchange),
        child: Container(
          padding: EdgeInsets.all(2.0),
          decoration: ShapeDecoration(
            shape: CircleBorder(),
            color: Color(0xff1133ff),
          ),
          child: Container(
            decoration: ShapeDecoration(
              shape: CircleBorder(),
              color: AppColors.blueColor,
            ),
            child: const Icon(
              Icons.category,
              color: Colors.white,
            ),
            height: 60.0,
            width: 60.0,
          ),
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    Key? key,
    this.opacity = 1,
  }) : super(key: key);
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        color: AppColors.greenCOlor.withOpacity(opacity),
      ),
    );
  }
}

class PositionOfFab extends StatelessWidget {
  const PositionOfFab({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 62,
      left: 0.0,
      right: 0.0,
      child: child,
    );
  }
}

class PositionOfIndicator extends StatelessWidget {
  const PositionOfIndicator({
    Key? key,
    required this.child,
    required this.selectedItem,
  }) : super(key: key);
  final Widget child;
  final MenuItems selectedItem;

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
        alignment: Alignment(selectedItem.alignX, 1),
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeOutExpo,
        child: child);
  } //10 //86, //156(center) //right: 86//right: 10
}

enum MenuItems { home, wallet, exchange, markets, profile }

extension MenuItemsPosition on MenuItems {
  double get alignX {
    switch (this) {
      case MenuItems.home:
        return -0.95;
      case MenuItems.wallet:
        return -.45;
      case MenuItems.exchange:
        return 0;
      case MenuItems.markets:
        return .45;
      case MenuItems.profile:
        return .95;
    }
  }

  AnimatedIconData get icon {
    switch (this) {
      case MenuItems.home:
        return AnimatedIcons.home_menu;
      case MenuItems.wallet:
        return AnimatedIcons.ellipsis_search;
      case MenuItems.exchange:
        return AnimatedIcons.event_add;
      case MenuItems.markets:
        return AnimatedIcons.pause_play;
      case MenuItems.profile:
        return AnimatedIcons.view_list;
    }
  }
}
