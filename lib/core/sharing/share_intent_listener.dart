import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_moment/core/sharing/share_intent_utils.dart';
import 'package:last_moment/features/playlist_length/presentation/playlist_length_screen.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

/// Listens for shared YouTube playlist URLs and navigates to the calculator screen.
class ShareIntentListener extends StatefulWidget {
  const ShareIntentListener({
    super.key,
    required this.navigatorKey,
    required this.child,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  State<ShareIntentListener> createState() => _ShareIntentListenerState();
}

class _ShareIntentListenerState extends State<ShareIntentListener> {
  StreamSubscription<List<SharedMediaFile>>? _shareSubscription;
  StreamSubscription<User?>? _authSubscription;
  String? _pendingPlaylistUrl;

  @override
  void initState() {
    super.initState();
    _initShareListener();
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen(_onAuthChanged);
  }

  void _initShareListener() {
    _shareSubscription =
        ReceiveSharingIntent.instance.getMediaStream().listen(_handleSharedMedia);

    ReceiveSharingIntent.instance.getInitialMedia().then(_handleSharedMedia);
  }

  void _onAuthChanged(User? user) {
    if (user != null && _pendingPlaylistUrl != null) {
      final url = _pendingPlaylistUrl!;
      _pendingPlaylistUrl = null;
      _openPlaylistScreen(url);
    }
  }

  void _handleSharedMedia(List<SharedMediaFile> media) {
    if (media.isEmpty) return;

    final playlistUrl = ShareIntentUtils.extractFromSharedMedia(media);
    ReceiveSharingIntent.instance.reset();

    if (playlistUrl == null) return;

    if (FirebaseAuth.instance.currentUser == null) {
      _pendingPlaylistUrl = playlistUrl;
      return;
    }

    _openPlaylistScreen(playlistUrl);
  }

  void _openPlaylistScreen(String playlistUrl) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => PlaylistLengthScreen(
            initialPlaylistUrl: playlistUrl,
            autoAnalyze: true,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _shareSubscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
