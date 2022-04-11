import 'package:flutter/material.dart';

class CustomIcon extends StatefulWidget {
  VoidCallback onMenuTap;

  CustomIcon({Key? key, required this.onMenuTap}) : super(key: key);
  @override
  _CustomIconState createState() => _CustomIconState();
}

class _CustomIconState extends State<CustomIcon> with TickerProviderStateMixin {
  late AnimationController _animationIconController1;
  bool isarrowmenu = false;

  @override
  void initState() {
    super.initState();
    _animationIconController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
      reverseDuration: const Duration(milliseconds: 750),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isarrowmenu
              ? _animationIconController1.reverse()
              : _animationIconController1.forward();
          isarrowmenu = !isarrowmenu;

          if (widget.onMenuTap != null) {
            widget.onMenuTap();
          }
        });
      },
      child: ClipOval(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.5,
              color: Colors.green,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(50.0),
            ),
          ),
          width: 75,
          height: 75,
          child: Center(
            child: AnimatedIcon(
              icon: AnimatedIcons.home_menu,
              progress: _animationIconController1,
              color: Colors.red,
              size: 60,
            ),
          ),
        ),
      ),
    );
  }
}