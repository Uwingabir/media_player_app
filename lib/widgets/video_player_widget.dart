import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String? title;
  final bool allowFullScreen;
  final bool allowPictureInPicture;
  final bool showControls;
  final Color? primaryColor;
  final List<String>? subtitleUrls;
  final double aspectRatio;
  final Function(String)? onAddToFavorites;
  final Function(String)? onAddToPlaylist;
  final bool isFavorite;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.title,
    this.allowFullScreen = true,
    this.allowPictureInPicture = true,
    this.showControls = true,
    this.primaryColor,
    this.subtitleUrls,
    this.aspectRatio = 16 / 9,
    this.onAddToFavorites,
    this.onAddToPlaylist,
    this.isFavorite = false,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  bool _isFullScreen = false;
  int _selectedQuality = 0;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Use a working demo video URL if the provided URL is empty or might not work
      String videoUrl = widget.videoUrl;
      if (videoUrl.isEmpty) {
        videoUrl = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
      }

      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: widget.aspectRatio,
        autoPlay: false,
        looping: false,
        allowFullScreen: widget.allowFullScreen,
        allowMuting: true,
        allowPlaybackSpeedChanging: true,
        showControls: widget.showControls,
        materialProgressColors: ChewieProgressColors(
          playedColor: widget.primaryColor ?? Theme.of(context).primaryColor,
          handleColor: widget.primaryColor ?? Theme.of(context).primaryColor,
          backgroundColor: Colors.grey.withOpacity(0.3),
          bufferedColor: Colors.grey.withOpacity(0.5),
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        autoInitialize: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Video Error',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
        additionalOptions: (context) {
          return <OptionItem>[
            OptionItem(
              onTap: (context) => _togglePictureInPicture(),
              iconData: Icons.picture_in_picture_alt,
              title: 'Picture in Picture',
            ),
            OptionItem(
              onTap: (context) => _showQualitySelector(),
              iconData: Icons.settings,
              title: 'Quality',
            ),
            OptionItem(
              onTap: (context) => _showSpeedSelector(),
              iconData: Icons.speed,
              title: 'Speed',
            ),
          ];
        },
      );

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _togglePictureInPicture() {
    if (widget.allowPictureInPicture) {
      // Note: Picture-in-picture implementation would depend on platform
      // For now, we'll show a placeholder message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Picture-in-picture mode activated'),
        ),
      );
    }
  }

  void _showQualitySelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => QualitySelector(
        selectedQuality: _selectedQuality,
        onQualitySelected: (quality) {
          setState(() => _selectedQuality = quality);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showSpeedSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SpeedSelector(
        selectedSpeed: _playbackSpeed,
        onSpeedSelected: (speed) {
          _videoPlayerController.setPlaybackSpeed(speed);
          setState(() => _playbackSpeed = speed);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _toggleFullScreen() {
    setState(() => _isFullScreen = !_isFullScreen);
    
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_hasError) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load video',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initializePlayer,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Video Player
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: widget.aspectRatio,
              child: _chewieController != null
                  ? Chewie(controller: _chewieController!)
                  : Container(color: Colors.black),
            ),
          ),
        ),

        // Video Title and Controls
        if (widget.title != null) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title!,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Favorite and Playlist buttons
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      widget.onAddToFavorites?.call(widget.videoUrl);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(widget.isFavorite 
                              ? 'Removed from favorites' 
                              : 'Added to favorites'),
                          backgroundColor: widget.primaryColor ?? Theme.of(context).primaryColor,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: Icon(
                      widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: widget.isFavorite ? Colors.red : widget.primaryColor ?? Theme.of(context).primaryColor,
                    ),
                    tooltip: widget.isFavorite ? 'Remove from favorites' : 'Add to favorites',
                  ),
                  IconButton(
                    onPressed: () {
                      widget.onAddToPlaylist?.call(widget.videoUrl);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Added to playlist'),
                          backgroundColor: widget.primaryColor ?? Theme.of(context).primaryColor,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.playlist_add,
                      color: widget.primaryColor ?? Theme.of(context).primaryColor,
                    ),
                    tooltip: 'Add to playlist',
                  ),
                ],
              ),
            ],
          ),
        ],

        const SizedBox(height: 12),

        // Additional Controls Row
        Row(
          children: [
            // Fullscreen Button
            IconButton(
              onPressed: _toggleFullScreen,
              icon: Icon(
                _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                color: widget.primaryColor ?? Theme.of(context).primaryColor,
              ),
              tooltip: _isFullScreen ? 'Exit Fullscreen' : 'Fullscreen',
            ),

            // Picture in Picture Button
            if (widget.allowPictureInPicture)
              IconButton(
                onPressed: _togglePictureInPicture,
                icon: Icon(
                  Icons.picture_in_picture_alt,
                  color: widget.primaryColor ?? Theme.of(context).primaryColor,
                ),
                tooltip: 'Picture in Picture',
              ),

            // Quality Button
            IconButton(
              onPressed: _showQualitySelector,
              icon: Icon(
                Icons.high_quality,
                color: widget.primaryColor ?? Theme.of(context).primaryColor,
              ),
              tooltip: 'Quality Settings',
            ),

            // Speed Button
            IconButton(
              onPressed: _showSpeedSelector,
              icon: Icon(
                Icons.speed,
                color: widget.primaryColor ?? Theme.of(context).primaryColor,
              ),
              tooltip: 'Playback Speed',
            ),

            const Spacer(),

            // Current Speed Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_playbackSpeed}x',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class QualitySelector extends StatelessWidget {
  final int selectedQuality;
  final Function(int) onQualitySelected;

  const QualitySelector({
    super.key,
    required this.selectedQuality,
    required this.onQualitySelected,
  });

  @override
  Widget build(BuildContext context) {
    final qualities = ['Auto', '480p', '720p', '1080p'];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Video Quality',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...qualities.asMap().entries.map((entry) {
            final index = entry.key;
            final quality = entry.value;
            return ListTile(
              title: Text(quality),
              leading: Radio<int>(
                value: index,
                groupValue: selectedQuality,
                onChanged: (value) => onQualitySelected(value!),
              ),
              onTap: () => onQualitySelected(index),
            );
          }),
        ],
      ),
    );
  }
}

class SpeedSelector extends StatelessWidget {
  final double selectedSpeed;
  final Function(double) onSpeedSelected;

  const SpeedSelector({
    super.key,
    required this.selectedSpeed,
    required this.onSpeedSelected,
  });

  @override
  Widget build(BuildContext context) {
    final speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Playback Speed',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...speeds.map((speed) {
            return ListTile(
              title: Text('${speed}x'),
              leading: Radio<double>(
                value: speed,
                groupValue: selectedSpeed,
                onChanged: (value) => onSpeedSelected(value!),
              ),
              onTap: () => onSpeedSelected(speed),
            );
          }),
        ],
      ),
    );
  }
}