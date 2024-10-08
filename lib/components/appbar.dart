import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:last_moment/components/pallet.dart';
import 'package:url_launcher/link.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Pallete.mainFontColor,
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
           Link(
            uri: Uri.parse('https://www.linkedin.com/in/saurabh-maurya-986a10259?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app'),
            builder: (context, followLink) => IconButton(
              onPressed: followLink,
              icon: SvgPicture.asset(
                'assets/linkd2.svg',
                height: 38,
              ),
            ),
          ),
         
          Link(
            uri: Uri.parse('https://github.com/Saurabhmaurya111/yt-len'),
            builder: (context, followLink) => IconButton(
              onPressed: followLink,
              icon: SvgPicture.asset(
                'assets/githubs.svg',
                height: 38,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
