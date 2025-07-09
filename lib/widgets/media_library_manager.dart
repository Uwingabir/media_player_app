import 'package:flutter/material.dart';

/// Manages favorites and playlists for media items
class MediaLibraryManager extends ChangeNotifier {
  final List<MediaItem> _favorites = [];
  final List<Playlist> _playlists = [];

  // Getters
  List<MediaItem> get favorites => List.unmodifiable(_favorites);
  List<Playlist> get playlists => List.unmodifiable(_playlists);

  // Favorites management
  bool isFavorite(String url) {
    return _favorites.any((item) => item.url == url);
  }

  void toggleFavorite(MediaItem item) {
    if (isFavorite(item.url)) {
      _favorites.removeWhere((fav) => fav.url == item.url);
    } else {
      _favorites.add(item);
    }
    notifyListeners();
  }

  void addToFavorites(MediaItem item) {
    if (!isFavorite(item.url)) {
      _favorites.add(item);
      notifyListeners();
    }
  }

  void removeFromFavorites(String url) {
    _favorites.removeWhere((item) => item.url == url);
    notifyListeners();
  }

  // Playlist management
  void createPlaylist(String name) {
    if (!_playlists.any((p) => p.name == name)) {
      _playlists.add(Playlist(name: name, items: []));
      notifyListeners();
    }
  }

  void deletePlaylist(String name) {
    _playlists.removeWhere((p) => p.name == name);
    notifyListeners();
  }

  void addToPlaylist(String playlistName, MediaItem item) {
    final playlist = _playlists.firstWhere(
      (p) => p.name == playlistName,
      orElse: () {
        final newPlaylist = Playlist(name: playlistName, items: []);
        _playlists.add(newPlaylist);
        return newPlaylist;
      },
    );
    
    if (!playlist.items.any((i) => i.url == item.url)) {
      playlist.items.add(item);
      notifyListeners();
    }
  }

  void removeFromPlaylist(String playlistName, String itemUrl) {
    final playlist = _playlists.firstWhere((p) => p.name == playlistName);
    playlist.items.removeWhere((item) => item.url == itemUrl);
    notifyListeners();
  }

  Playlist? getPlaylist(String name) {
    try {
      return _playlists.firstWhere((p) => p.name == name);
    } catch (e) {
      return null;
    }
  }
}

/// Represents a media item (audio or video)
class MediaItem {
  final String url;
  final MediaType type;
  final String title;
  final String? artist;
  final String? thumbnail;
  final Duration? duration;

  const MediaItem({
    required this.url,
    required this.type,
    required this.title,
    this.artist,
    this.thumbnail,
    this.duration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaItem && runtimeType == other.runtimeType && url == other.url;

  @override
  int get hashCode => url.hashCode;
}

/// Represents a playlist containing multiple media items
class Playlist {
  final String name;
  final List<MediaItem> items;
  final DateTime createdAt;

  Playlist({
    required this.name,
    required this.items,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get itemCount => items.length;
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  Duration get totalDuration {
    return items.fold(Duration.zero, (total, item) {
      return total + (item.duration ?? Duration.zero);
    });
  }
}

/// Media type enumeration
enum MediaType { audio, video }
