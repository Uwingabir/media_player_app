import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final String? title;
  final String? artist;
  final Color? primaryColor;
  final bool showPlaylist;
  final Function(String)? onAddToFavorites;
  final Function(String)? onAddToPlaylist;
  final bool isFavorite;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    this.title,
    this.artist,
    this.primaryColor,
    this.showPlaylist = false,
    this.onAddToFavorites,
    this.onAddToPlaylist,
    this.isFavorite = false,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _isMuted = false;
  double _volume = 1.0;
  double _speed = 1.0;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    setState(() => _isLoading = true);
    
    try {
      // Try to set URL, but don't fail if URL is invalid
      if (widget.audioUrl.isNotEmpty) {
        await _audioPlayer.setUrl(widget.audioUrl);
      } else {
        // Use a demo audio URL for testing
        await _audioPlayer.setUrl('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
      }
      
      // Listen to player state changes
      _audioPlayer.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
            _isLoading = state.processingState == ProcessingState.loading;
          });
        }
      });

      // Listen to position changes
      _audioPlayer.positionStream.listen((position) {
        if (mounted) {
          setState(() => _position = position);
        }
      });

      // Listen to duration changes
      _audioPlayer.durationStream.listen((duration) {
        if (mounted) {
          setState(() => _duration = duration ?? Duration.zero);
        }
      });

    } catch (e) {
      debugPrint('Error loading audio: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  Future<void> _stop() async {
    await _audioPlayer.stop();
    await _audioPlayer.seek(Duration.zero);
  }

  Future<void> _seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> _skipForward() async {
    final newPosition = _position + const Duration(seconds: 10);
    await _seek(newPosition > _duration ? _duration : newPosition);
  }

  Future<void> _skipBackward() async {
    final newPosition = _position - const Duration(seconds: 10);
    await _seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  Future<void> _toggleMute() async {
    setState(() => _isMuted = !_isMuted);
    await _audioPlayer.setVolume(_isMuted ? 0.0 : _volume);
  }

  Future<void> _setVolume(double volume) async {
    setState(() {
      _volume = volume;
      if (!_isMuted) {
        _audioPlayer.setVolume(volume);
      }
    });
  }

  Future<void> _setSpeed(double speed) async {
    setState(() => _speed = speed);
    await _audioPlayer.setSpeed(speed);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    return duration.inHours > 0 
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title and Artist
          if (widget.title != null || widget.artist != null) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.title != null)
                        Text(
                          widget.title!,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (widget.artist != null)
                        Text(
                          widget.artist!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
                // Favorite and Playlist buttons
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.onAddToFavorites?.call(widget.audioUrl);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(widget.isFavorite 
                                ? 'Removed from favorites' 
                                : 'Added to favorites'),
                            backgroundColor: primaryColor,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: Icon(
                        widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: widget.isFavorite ? Colors.red : primaryColor,
                      ),
                      tooltip: widget.isFavorite ? 'Remove from favorites' : 'Add to favorites',
                    ),
                    IconButton(
                      onPressed: () {
                        widget.onAddToPlaylist?.call(widget.audioUrl);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Added to playlist'),
                            backgroundColor: primaryColor,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.playlist_add,
                        color: primaryColor,
                      ),
                      tooltip: 'Add to playlist',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],

          // Progress Bar
          Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: primaryColor,
                  inactiveTrackColor: primaryColor.withOpacity(0.3),
                  thumbColor: primaryColor,
                  overlayColor: primaryColor.withOpacity(0.2),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: _duration.inMilliseconds > 0
                      ? _position.inMilliseconds / _duration.inMilliseconds
                      : 0.0,
                  onChanged: (value) {
                    final newPosition = Duration(
                      milliseconds: (value * _duration.inMilliseconds).round(),
                    );
                    _seek(newPosition);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Main Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: _skipBackward,
                icon: const Icon(Icons.replay_10),
                iconSize: 32,
                color: primaryColor,
              ),
              Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _isLoading ? null : _togglePlayPause,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                  iconSize: 40,
                ),
              ),
              IconButton(
                onPressed: _stop,
                icon: const Icon(Icons.stop),
                iconSize: 32,
                color: primaryColor,
              ),
              IconButton(
                onPressed: _skipForward,
                icon: const Icon(Icons.forward_10),
                iconSize: 32,
                color: primaryColor,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Additional Controls
          Row(
            children: [
              // Volume Control
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _toggleMute,
                      icon: Icon(
                        _isMuted ? Icons.volume_off : Icons.volume_up,
                        color: primaryColor,
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: primaryColor,
                          inactiveTrackColor: primaryColor.withOpacity(0.3),
                          thumbColor: primaryColor,
                          trackHeight: 2,
                        ),
                        child: Slider(
                          value: _isMuted ? 0.0 : _volume,
                          onChanged: _setVolume,
                          min: 0.0,
                          max: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // Speed Control
              Row(
                children: [
                  const Icon(Icons.speed, color: Colors.grey),
                  const SizedBox(width: 8),
                  DropdownButton<double>(
                    value: _speed,
                    onChanged: (speed) => _setSpeed(speed!),
                    items: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
                        .map((speed) => DropdownMenuItem(
                              value: speed,
                              child: Text('${speed}x'),
                            ))
                        .toList(),
                    underline: Container(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}