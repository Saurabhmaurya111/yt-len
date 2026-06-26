import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_moment/core/theme/app_palette.dart';
import 'package:last_moment/features/playlist_compare/presentation/playlist_compare_screen.dart';
import 'package:last_moment/features/playlist_length/presentation/playlist_length_screen.dart';
import 'package:last_moment/shared/widgets/featured_box.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final userName = FirebaseAuth.instance.currentUser?.displayName ??
        FirebaseAuth.instance.currentUser?.email?.split('@').first ??
        'there';

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/logo.png',
                        height: 44,
                        width: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Last Moment',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Sign out',
                      onPressed: _signUserOut,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surfaceVariant,
                      ),
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: AppColors.textSecondary,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.authGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_greeting()}, $userName 👋',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'What would you like to explore today?',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 28, 20, 8),
                child: Text(
                  'Features',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  FeatureBox(
                    headerText: 'Playlist Calculator',
                    description:
                        'Calculate total watch time, average length, and speed-adjusted durations.',
                    icon: Icons.timer_outlined,
                    gradient: AppColors.lengthGradient,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlaylistLengthScreen(),
                        ),
                      );
                    },
                  ),
                  FeatureBox(
                    headerText: 'Compare Playlists',
                    description:
                        'Compare views, likes, and engagement between two YouTube playlists.',
                    icon: Icons.compare_arrows_rounded,
                    gradient: AppColors.compareGradient,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlaylistCompareScreen(),
                        ),
                      );
                    },
                  ),
                  const FeatureBox(
                    headerText: 'Study Planner',
                    description:
                        'Smart study plans based on your playlists — launching soon.',
                    icon: Icons.calendar_month_outlined,
                    gradient: AppColors.planGradient,
                    isComingSoon: true,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
