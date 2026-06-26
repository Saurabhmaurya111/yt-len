import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/link.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    this.showBackButton = true,
    this.title,
  });

  final bool showBackButton;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            )
          : Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 36,
                    width: 36,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Last Moment',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ],
            ),
      actions: [
        Link(
          uri: Uri.parse(
            'https://www.linkedin.com/in/saurabh-maurya-986a10259',
          ),
          builder: (context, followLink) => IconButton(
            tooltip: 'LinkedIn',
            onPressed: followLink,
            icon: SvgPicture.asset('assets/linkd2.svg', height: 24),
          ),
        ),
        Link(
          uri: Uri.parse('https://github.com/Saurabhmaurya111/yt-len'),
          builder: (context, followLink) => IconButton(
            tooltip: 'GitHub',
            onPressed: followLink,
            icon: SvgPicture.asset('assets/githubs.svg', height: 24),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
