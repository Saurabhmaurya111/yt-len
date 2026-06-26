import 'package:flutter/material.dart';
import 'package:last_moment/core/theme/app_palette.dart';
import 'package:last_moment/core/utils/duration_utils.dart';
import 'package:last_moment/data/models/api_result.dart';
import 'package:last_moment/data/models/playlist_length_result.dart';
import 'package:last_moment/data/repositories/playlist_repository.dart';
import 'package:last_moment/shared/widgets/app_footer.dart';
import 'package:last_moment/shared/widgets/custom_app_bar.dart';
import 'package:last_moment/shared/widgets/custom_search_bar.dart';
import 'package:last_moment/shared/widgets/page_header.dart';
import 'package:last_moment/shared/widgets/primary_button.dart';
import 'package:last_moment/shared/widgets/result_stat_card.dart';
import 'package:lottie/lottie.dart';

class PlaylistLengthScreen extends StatefulWidget {
const PlaylistLengthScreen({
    super.key,
    this.initialPlaylistUrl,
    this.autoAnalyze = false,
  });

  final String? initialPlaylistUrl;
  final bool autoAnalyze;

  @override
  State<PlaylistLengthScreen> createState() => _PlaylistLengthScreenState();
}

class _PlaylistLengthScreenState extends State<PlaylistLengthScreen> {
  final TextEditingController _controller = TextEditingController();
  final PlaylistRepository _repository = PlaylistRepository();

  PlaylistLengthResult? _result;
  String? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final url = widget.initialPlaylistUrl;
    if (url != null && url.isNotEmpty) {
      _controller.text = url;
      if (widget.autoAnalyze) {
        WidgetsBinding.instance.addPostFrameCallback((_) => analyzePlaylist());
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> analyzePlaylist() async {
    final playlistUrl = _controller.text.trim();
    if (playlistUrl.isEmpty) {
      setState(() => _error = 'Please paste a playlist URL');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });

    final apiResult = await _repository.getPlaylistLength(playlistUrl);

    if (!mounted) return;

    setState(() {
      _loading = false;
      switch (apiResult) {
        case ApiSuccess(:final data):
          _result = data;
        case ApiFailure(:final message):
          _error = message;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Playlist Calculator'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PageHeader(
              title: 'Playlist Length',
              subtitle: 'Paste any YouTube playlist link to get watch-time stats.',
              icon: Icons.playlist_play_rounded,
              gradient: AppColors.lengthGradient,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomSearchBar(
                      controller: _controller,
                      hint: 'https://youtube.com/playlist?list=...',
                      label: 'Playlist URL',
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: 'Analyze Playlist',
                      icon: Icons.analytics_outlined,
                      isLoading: _loading,
                      onPressed: analyzePlaylist,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_loading)
              Center(
                child: Lottie.asset(
                  'assets/load3.json',
                  height: 160,
                ),
              ),
            if (_error != null) _buildErrorCard(_error!),
            if (_result != null) _buildResults(_result!),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
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
              message,
              style: const TextStyle(color: AppColors.error, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(PlaylistLengthResult data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Results',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ResultStatCard(
          icon: Icons.video_library_outlined,
          label: 'Total Videos',
          value: '${data.videoCount}',
          accentColor: AppColors.primary,
        ),
        const SizedBox(height: 10),
        ResultStatCard(
          icon: Icons.schedule_rounded,
          label: 'Total Watch Time',
          value: DurationUtils.format(data.totalDurationSeconds),
          accentColor: AppColors.primaryDark,
        ),
        const SizedBox(height: 10),
        ResultStatCard(
          icon: Icons.av_timer_rounded,
          label: 'Average Video Length',
          value: DurationUtils.format(data.averageDurationSeconds),
          accentColor: AppColors.primaryLight,
        ),
        const SizedBox(height: 16),
        const Text(
          'At Different Speeds',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _SpeedChip(label: '1.25×', seconds: data.durationAtSpeed(1.25)),
            _SpeedChip(label: '1.5×', seconds: data.durationAtSpeed(1.5)),
            _SpeedChip(label: '1.75×', seconds: data.durationAtSpeed(1.75)),
            _SpeedChip(label: '2×', seconds: data.durationAtSpeed(2)),
          ],
        ),
      ],
    );
  }
}

class _SpeedChip extends StatelessWidget {
  const _SpeedChip({required this.label, required this.seconds});

  final String label;
  final int seconds;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            DurationUtils.format(seconds),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
