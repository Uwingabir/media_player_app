import 'package:flutter/material.dart';
import '../widgets/audio_player_widget.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/unified_media_player.dart';

class MediaPlayerDemoPage extends StatefulWidget {
  const MediaPlayerDemoPage({super.key});

  @override
  State<MediaPlayerDemoPage> createState() => _MediaPlayerDemoPageState();
}

class _MediaPlayerDemoPageState extends State<MediaPlayerDemoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample media URLs - replace with your actual media URLs
  final String _sampleAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
  final String _sampleVideoUrl = 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4';

  final List<MediaItem> _samplePlaylist = [
    MediaItem(
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      type: MediaType.audio,
      title: 'SoundHelix Song 1',
      artist: 'SoundHelix',
    ),
    MediaItem(
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      type: MediaType.audio,
      title: 'SoundHelix Song 2',
      artist: 'SoundHelix',
    ),
    MediaItem(
      url: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      type: MediaType.video,
      title: 'Sample Video 1',
      artist: 'Demo',
    ),
    MediaItem(
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      type: MediaType.audio,
      title: 'SoundHelix Song 3',
      artist: 'SoundHelix',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Media Player Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.music_note), text: 'Audio'),
            Tab(icon: Icon(Icons.video_library), text: 'Video'),
            Tab(icon: Icon(Icons.queue_music), text: 'Unified'),
            Tab(icon: Icon(Icons.playlist_play), text: 'Advanced'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAudioPlayerDemo(),
          _buildVideoPlayerDemo(),
          _buildUnifiedPlayerDemo(),
          _buildAdvancedPlayerDemo(),
        ],
      ),
    );
  }

  Widget _buildAudioPlayerDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Audio Player Widget',
            'Complete audio player with all essential controls',
          ),
          const SizedBox(height: 16),
          
          // Basic Audio Player
          AudioPlayerWidget(
            audioUrl: _sampleAudioUrl,
            title: 'Sample Audio Track',
            artist: 'Demo Artist',
            primaryColor: Colors.deepPurple,
          ),

          const SizedBox(height: 32),

          _buildSectionHeader(
            'Features Included',
            'All the core components for audio playback',
          ),
          const SizedBox(height: 16),

          _buildFeatureList([
            'Play/Pause/Stop Controls',
            'Progress Bar with Scrubbing',
            'Volume Control with Mute',
            'Playback Speed Adjustment',
            'Skip Forward/Backward (10s)',
            'Duration Display',
            'Loading States',
            'Beautiful UI with Gradients',
          ]),

          const SizedBox(height: 32),

          // Custom Themed Audio Player
          AudioPlayerWidget(
            audioUrl: _sampleAudioUrl,
            title: 'Custom Themed Player',
            artist: 'Custom Theme Demo',
            primaryColor: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayerDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Video Player Widget',
            'Advanced video player with visual controls',
          ),
          const SizedBox(height: 16),

          VideoPlayerWidget(
            videoUrl: _sampleVideoUrl,
            title: 'Sample Video Content',
            allowFullScreen: true,
            allowPictureInPicture: true,
            primaryColor: Colors.red,
          ),

          const SizedBox(height: 32),

          _buildSectionHeader(
            'Video-Specific Features',
            'Enhanced features for video content',
          ),
          const SizedBox(height: 16),

          _buildFeatureList([
            'Fullscreen Mode Support',
            'Picture-in-Picture Mode',
            'Quality Selection (480p, 720p, 1080p)',
            'Speed Control (0.25x to 2x)',
            'Responsive Video Display',
            'Error Handling with Retry',
            'Custom Control Overlays',
            'Aspect Ratio Management',
          ]),
        ],
      ),
    );
  }

  Widget _buildUnifiedPlayerDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Unified Media Player',
            'Single player that handles both audio and video',
          ),
          const SizedBox(height: 16),

          UnifiedMediaPlayer(
            mediaUrl: _sampleAudioUrl,
            mediaType: MediaType.audio,
            title: 'Unified Audio Example',
            artist: 'Demo Artist',
            primaryColor: Colors.indigo,
            playlist: _samplePlaylist,
            showPlaylist: true,
            onMediaChanged: (index) {
              debugPrint('Media changed to index: $index');
            },
          ),

          const SizedBox(height: 32),

          _buildSectionHeader(
            'Unified Player Benefits',
            'One widget for all your media needs',
          ),
          const SizedBox(height: 16),

          _buildFeatureList([
            'Automatic Media Type Detection',
            'Playlist Support',
            'Previous/Next Navigation',
            'Unified Control Interface',
            'Consistent Theming',
            'Dynamic UI Adaptation',
            'Playlist Visualization',
            'Media Type Indicators',
          ]),
        ],
      ),
    );
  }

  Widget _buildAdvancedPlayerDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Advanced Unified Player',
            'Full-featured player with enhanced controls',
          ),
          const SizedBox(height: 16),

          AdvancedUnifiedMediaPlayer(
            playlist: _samplePlaylist,
            initialIndex: 0,
            primaryColor: Colors.purple,
            enableShuffle: true,
            enableRepeat: true,
            onMediaChanged: (index) {
              debugPrint('Advanced player - media changed to: $index');
            },
            onMediaFavorited: (media) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added "${media.title}" to favorites'),
                  backgroundColor: Colors.purple,
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          _buildSectionHeader(
            'Advanced Features',
            'Professional-grade media player capabilities',
          ),
          const SizedBox(height: 16),

          _buildFeatureList([
            'Shuffle Mode with Random Playback',
            'Repeat Modes (None, All, One)',
            'Favorite/Like Functionality',
            'Share Media Content',
            'Enhanced Visual Design',
            'Gradient Backgrounds',
            'Advanced Playlist Management',
            'Professional UI/UX',
          ]),

          const SizedBox(height: 32),

          _buildSectionHeader(
            'Technical Implementation',
            'Built with modern Flutter best practices',
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dependencies Used:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('• just_audio: Advanced audio playback'),
                const Text('• video_player: Core video functionality'),
                const Text('• chewie: Enhanced video player UI'),
                const Text('• audioplayers: Alternative audio support'),
                const SizedBox(height: 16),
                Text(
                  'Key Features:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('• Multiple format support (MP3, MP4, WebM)'),
                const Text('• Responsive design across all devices'),
                const Text('• Accessibility support'),
                const Text('• Efficient buffering and seeking'),
                const Text('• Customizable styling'),
                const Text('• Plugin architecture ready'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureList(List<String> features) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: features.map((feature) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: Colors.green[600],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    feature,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}