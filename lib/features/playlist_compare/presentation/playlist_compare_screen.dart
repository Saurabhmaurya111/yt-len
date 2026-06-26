import 'package:flutter/material.dart';
import 'package:last_moment/core/theme/app_palette.dart';
import 'package:last_moment/data/models/api_result.dart';
import 'package:last_moment/data/models/playlist_stats.dart';
import 'package:last_moment/data/repositories/playlist_repository.dart';
import 'package:last_moment/shared/widgets/app_footer.dart';
import 'package:last_moment/shared/widgets/custom_app_bar.dart';
import 'package:last_moment/shared/widgets/custom_search_bar.dart';
import 'package:last_moment/shared/widgets/page_header.dart';
import 'package:last_moment/shared/widgets/primary_button.dart';
import 'package:last_moment/shared/widgets/result_stat_card.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:url_launcher/link.dart';

class PlaylistCompareScreen extends StatefulWidget {
  const PlaylistCompareScreen({super.key});

  @override
  State<PlaylistCompareScreen> createState() => _PlaylistCompareScreenState();
}

class _PlaylistCompareScreenState extends State<PlaylistCompareScreen> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final PlaylistRepository _repository = PlaylistRepository();

  PlaylistStats? _stats1;
  PlaylistStats? _stats2;
  String? _error;
  String? _winnerMessage;
  String? _winnerUrl;
  bool _loading = false;

  Future<void> comparePlaylists() async {
    if (_controller1.text.trim().isEmpty || _controller2.text.trim().isEmpty) {
      setState(() => _error = 'Please enter both playlist URLs');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _stats1 = null;
      _stats2 = null;
      _winnerMessage = null;
      _winnerUrl = null;
    });

    final results1 = await _repository.getPlaylistStats(_controller1.text);
    final results2 = await _repository.getPlaylistStats(_controller2.text);

    if (!mounted) return;

    late final PlaylistStats stats1;
    late final PlaylistStats stats2;

    switch (results1) {
      case ApiSuccess(:final data):
        stats1 = data;
      case ApiFailure(:final message):
        setState(() {
          _error = 'Playlist 1: $message';
          _loading = false;
        });
        return;
    }

    switch (results2) {
      case ApiSuccess(:final data):
        stats2 = data;
      case ApiFailure(:final message):
        setState(() {
          _error = 'Playlist 2: $message';
          _loading = false;
        });
        return;
    }

    final p1 = stats1.likePercentage;
    final p2 = stats2.likePercentage;

    setState(() {
      _stats1 = stats1;
      _stats2 = stats2;
      _loading = false;

      if (p1 > p2) {
        _winnerMessage = 'Playlist 1 has better engagement';
        _winnerUrl = _controller1.text;
      } else if (p2 > p1) {
        _winnerMessage = 'Playlist 2 has better engagement';
        _winnerUrl = _controller2.text;
      } else {
        _winnerMessage = 'Both playlists have equal engagement';
      }
    });
  }

  void showStatsSheet() {
    if (_stats1 == null || _stats2 == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Engagement Comparison',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            _buildPercentRing(
              label: 'Playlist 1',
              percent: _stats1!.likePercentage,
              color: AppColors.compareGradient.first,
            ),
            const SizedBox(height: 24),
            _buildPercentRing(
              label: 'Playlist 2',
              percent: _stats2!.likePercentage,
              color: AppColors.compareGradient.last,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentRing({
    required String label,
    required double percent,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        CircularPercentIndicator(
          radius: 70,
          animation: true,
          animationDuration: 1200,
          lineWidth: 12,
          percent: (percent / 100).clamp(0.0, 1.0),
          center: Text(
            '${percent.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: AppColors.surfaceVariant,
          progressColor: color,
        ),
      ],
    );
  }

  Widget _buildPlaylistCard(String title, PlaylistStats stats, Color accent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ResultStatCard(
            icon: Icons.video_library_outlined,
            label: 'Videos',
            value: '${stats.videoCount}',
            accentColor: accent,
          ),
          const SizedBox(height: 8),
          ResultStatCard(
            icon: Icons.visibility_outlined,
            label: 'Total Views',
            value: _formatNumber(stats.totalViews),
            accentColor: accent,
          ),
          const SizedBox(height: 8),
          ResultStatCard(
            icon: Icons.thumb_up_outlined,
            label: 'Total Likes',
            value: _formatNumber(stats.totalLikes),
            accentColor: accent,
          ),
          const SizedBox(height: 8),
          ResultStatCard(
            icon: Icons.trending_up_rounded,
            label: 'Like Rate',
            value: '${stats.likePercentage.toStringAsFixed(2)}%',
            accentColor: accent,
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Compare Playlists'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PageHeader(
              title: 'Compare Playlists',
              subtitle: 'See which playlist performs better by views and likes.',
              icon: Icons.compare_arrows_rounded,
              gradient: AppColors.compareGradient,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomSearchBar(
                      controller: _controller1,
                      hint: 'Paste playlist 1 URL',
                      label: 'Playlist 1',
                    ),
                    const SizedBox(height: 16),
                    CustomSearchBar(
                      controller: _controller2,
                      hint: 'Paste playlist 2 URL',
                      label: 'Playlist 2',
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: 'Compare Playlists',
                      icon: Icons.bar_chart_rounded,
                      isLoading: _loading,
                      onPressed: comparePlaylists,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_loading)
              Center(child: Lottie.asset('assets/load3.json', height: 160)),
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: AppColors.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: AppColors.error, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            if (_stats1 != null && _stats2 != null) ...[
              const SizedBox(height: 8),
              _buildPlaylistCard('Playlist 1', _stats1!, AppColors.compareGradient.first),
              const SizedBox(height: 12),
              _buildPlaylistCard('Playlist 2', _stats2!, AppColors.compareGradient.last),
              const SizedBox(height: 16),
              if (_winnerMessage != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.success.withValues(alpha: 0.12),
                        AppColors.success.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.emoji_events_outlined, color: AppColors.success, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        _winnerMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (_winnerUrl != null) ...[
                        const SizedBox(height: 8),
                        Link(
                          uri: Uri.parse(_winnerUrl!),
                          builder: (context, followLink) => TextButton.icon(
                            onPressed: followLink,
                            icon: const Icon(Icons.open_in_new_rounded, size: 18),
                            label: const Text('Open winning playlist'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'View Engagement Chart',
                icon: Icons.pie_chart_outline_rounded,
                onPressed: showStatsSheet,
              ),
            ],
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
