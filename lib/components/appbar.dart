

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color.fromRGBO(17, 20, 23, 1),
      title: Row(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logo.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/githubs.svg',
              height: 38,
            ),
          ),
        ],
      ),
    );
    
  }
   @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}