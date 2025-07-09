import 'package:flutter/material.dart';
import 'audio_player_widget.dart';
import 'video_player_widget.dart';

enum MediaType { audio, video }

class UnifiedMediaPlayer extends StatefulWidget {
  final String mediaUrl;
  final MediaType mediaType;
  final String? title;
  final String? artist;
  final Color? primaryColor;
  final bool allowFullScreen;
  final bool showPlaylist;
  final List<MediaItem>? playlist;
  final int? currentIndex;
  final Function(int)? onMediaChanged;

  const UnifiedMediaPlayer({
    super.key,
    required this.mediaUrl,
    required this.mediaType,
    this.title,
    this.artist,
    this.primaryColor,
    this.allowFullScreen = true,
    this.showPlaylist = false,
    this.playlist,
    this.currentIndex,
    this.onMediaChanged,
  });

  @override
  State<UnifiedMediaPlayer> createState() => _UnifiedMediaPlayerState();
}

class _UnifiedMediaPlayerState extends State<UnifiedMediaPlayer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentPlaylistIndex = 0;
  bool _isPlaylistVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentPlaylistIndex = widget.currentIndex ?? 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  MediaItem get _currentMedia {
    if (widget.playlist != null && 
        _currentPlaylistIndex < widget.playlist!.length) {
      return widget.playlist![_currentPlaylistIndex];
    }
    return MediaItem(
      url: widget.mediaUrl,
      type: widget.mediaType,
      title: widget.title,
      artist: widget.artist,
    );
  }

  void _playNext() {
    if (widget.playlist != null && 
        _currentPlaylistIndex < widget.playlist!.length - 1) {
      setState(() => _currentPlaylistIndex++);
      widget.onMediaChanged?.call(_currentPlaylistIndex);
    }
  }

  void _playPrevious() {
    if (widget.playlist != null && _currentPlaylistIndex > 0) {
      setState(() => _currentPlaylistIndex--);
      widget.onMediaChanged?.call(_currentPlaylistIndex);
    }
  }

  void _playFromPlaylist(int index) {
    setState(() => _currentPlaylistIndex = index);
    widget.onMediaChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.primaryColor ?? theme.primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with media type tabs
          if (widget.playlist?.any((item) => item.type != _currentMedia.type) == true)
            Container(
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryColor,
                tabs: const [
                  Tab(icon: Icon(Icons.music_note), text: 'Audio'),
                  Tab(icon: Icon(Icons.video_library), text: 'Video'),
                ],
              ),
            ),

          // Media Player Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Main Player
                _buildMainPlayer(),

                // Playlist Controls
                if (widget.playlist != null) ...[
                  const SizedBox(height: 16),
                  _buildPlaylistControls(),
                ],

                // Playlist
                if (_isPlaylistVisible && widget.playlist != null) ...[
                  const SizedBox(height: 16),
                  _buildPlaylist(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainPlayer() {
    final media = _currentMedia;
    
    switch (media.type) {
      case MediaType.audio:
        return AudioPlayerWidget(
          audioUrl: media.url,
          title: media.title,
          artist: media.artist,
          primaryColor: widget.primaryColor,
        );
      case MediaType.video:
        return VideoPlayerWidget(
          videoUrl: media.url,
          title: media.title,
          allowFullScreen: widget.allowFullScreen,
          primaryColor: widget.primaryColor,
        );
    }
  }

  Widget _buildPlaylistControls() {
    final theme = Theme.of(context);
    final primaryColor = widget.primaryColor ?? theme.primaryColor;

    return Column(
      children: [
        // Previous/Next Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: _currentPlaylistIndex > 0 ? _playPrevious : null,
              icon: const Icon(Icons.skip_previous),
              iconSize: 32,
              color: primaryColor,
            ),
            IconButton(
              onPressed: () {
                setState(() => _isPlaylistVisible = !_isPlaylistVisible);
              },
              icon: Icon(
                _isPlaylistVisible ? Icons.playlist_remove : Icons.playlist_play,
              ),
              iconSize: 32,
              color: primaryColor,
            ),
            IconButton(
              onPressed: _currentPlaylistIndex < widget.playlist!.length - 1 
                  ? _playNext 
                  : null,
              icon: const Icon(Icons.skip_next),
              iconSize: 32,
              color: primaryColor,
            ),
          ],
        ),

        // Playlist indicator
        Text(
          '${_currentPlaylistIndex + 1} of ${widget.playlist!.length}',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildPlaylist() {
    final theme = Theme.of(context);
    final primaryColor = widget.primaryColor ?? theme.primaryColor;

    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.playlist!.length,
        itemBuilder: (context, index) {
          final media = widget.playlist![index];
          final isSelected = index == _currentPlaylistIndex;

          return ListTile(
            selected: isSelected,
            selectedTileColor: primaryColor.withOpacity(0.1),
            leading: CircleAvatar(
              backgroundColor: isSelected ? primaryColor : Colors.grey[300],
              child: Icon(
                media.type == MediaType.audio 
                    ? Icons.music_note 
                    : Icons.video_library,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
            title: Text(
              media.title ?? 'Unknown Title',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? primaryColor : null,
              ),
            ),
            subtitle: media.artist != null 
                ? Text(media.artist!) 
                : null,
            trailing: isSelected 
                ? Icon(Icons.volume_up, color: primaryColor)
                : null,
            onTap: () => _playFromPlaylist(index),
          );
        },
      ),
    );
  }
}

class MediaItem {
  final String url;
  final MediaType type;
  final String? title;
  final String? artist;
  final String? thumbnail;
  final Duration? duration;

  const MediaItem({
    required this.url,
    required this.type,
    this.title,
    this.artist,
    this.thumbnail,
    this.duration,
  });
}

// Advanced Unified Player with more features
class AdvancedUnifiedMediaPlayer extends StatefulWidget {
  final List<MediaItem> playlist;
  final int initialIndex;
  final Color? primaryColor;
  final bool enableShuffle;
  final bool enableRepeat;
  final Function(int)? onMediaChanged;
  final Function(MediaItem)? onMediaFavorited;

  const AdvancedUnifiedMediaPlayer({
    super.key,
    required this.playlist,
    this.initialIndex = 0,
    this.primaryColor,
    this.enableShuffle = true,
    this.enableRepeat = true,
    this.onMediaChanged,
    this.onMediaFavorited,
  });

  @override
  State<AdvancedUnifiedMediaPlayer> createState() => 
      _AdvancedUnifiedMediaPlayerState();
}

class _AdvancedUnifiedMediaPlayerState extends State<AdvancedUnifiedMediaPlayer> {
  int _currentIndex = 0;
  bool _isShuffled = false;
  RepeatMode _repeatMode = RepeatMode.none;
  List<int> _shuffledIndices = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _shuffledIndices = List.generate(widget.playlist.length, (index) => index);
  }

  MediaItem get _currentMedia => widget.playlist[_currentIndex];

  void _toggleShuffle() {
    setState(() {
      _isShuffled = !_isShuffled;
      if (_isShuffled) {
        _shuffledIndices.shuffle();
      } else {
        _shuffledIndices = List.generate(widget.playlist.length, (index) => index);
      }
    });
  }

  void _toggleRepeat() {
    setState(() {
      switch (_repeatMode) {
        case RepeatMode.none:
          _repeatMode = RepeatMode.all;
          break;
        case RepeatMode.all:
          _repeatMode = RepeatMode.one;
          break;
        case RepeatMode.one:
          _repeatMode = RepeatMode.none;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.primaryColor ?? theme.primaryColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Enhanced Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: widget.enableShuffle ? _toggleShuffle : null,
                icon: Icon(
                  Icons.shuffle,
                  color: _isShuffled ? primaryColor : Colors.grey,
                ),
              ),
              IconButton(
                onPressed: widget.enableRepeat ? _toggleRepeat : null,
                icon: Icon(
                  _repeatMode == RepeatMode.one 
                      ? Icons.repeat_one
                      : Icons.repeat,
                  color: _repeatMode != RepeatMode.none 
                      ? primaryColor 
                      : Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () => widget.onMediaFavorited?.call(_currentMedia),
                icon: const Icon(Icons.favorite_border),
                color: primaryColor,
              ),
              IconButton(
                onPressed: () {
                  // Share functionality
                },
                icon: const Icon(Icons.share),
                color: primaryColor,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Main Player
          UnifiedMediaPlayer(
            mediaUrl: _currentMedia.url,
            mediaType: _currentMedia.type,
            title: _currentMedia.title,
            artist: _currentMedia.artist,
            primaryColor: primaryColor,
            playlist: widget.playlist,
            currentIndex: _currentIndex,
            onMediaChanged: (index) {
              setState(() => _currentIndex = index);
              widget.onMediaChanged?.call(index);
            },
          ),
        ],
      ),
    );
  }
}

enum RepeatMode { none, all, one }