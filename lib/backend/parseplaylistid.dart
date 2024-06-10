

  String? parsePlaylistId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.queryParameters.containsKey('list')) {
      return null;
    }   
    return uri.queryParameters['list'];
  }