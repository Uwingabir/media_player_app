import 'package:flutter/material.dart';

/// A simple demo showing media player widget features
/// This demo explains what media players can do in an easy-to-understand way
class SimpleMediaPlayerDemo extends StatefulWidget {
  const SimpleMediaPlayerDemo({super.key});

  @override
  State<SimpleMediaPlayerDemo> createState() => _SimpleMediaPlayerDemoState();
}

class _SimpleMediaPlayerDemoState extends State<SimpleMediaPlayerDemo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    // We have 3 tabs: Features, How it Works, and Code Examples
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          '🎵 Media Player Widgets',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.star), text: 'Features'),
            Tab(icon: Icon(Icons.play_circle), text: 'How it Works'),
            Tab(icon: Icon(Icons.code), text: 'Code'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeaturesTab(),
          _buildHowItWorksTab(),
          _buildCodeExamplesTab(),
        ],
      ),
    );
  }

  /// TAB 1: Shows what our media player can do
  Widget _buildFeaturesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 20),
          _buildSimpleFeatureCard(
            '🎵 Audio Player',
            'Plays music and audio files',
            Colors.purple,
            [
              'Play and pause music',
              'Skip 10 seconds forward/back',
              'Control volume',
              'Change playback speed',
              'See progress bar',
            ],
          ),
          const SizedBox(height: 20),
          _buildSimpleFeatureCard(
            '🎬 Video Player',
            'Plays videos with all controls',
            Colors.red,
            [
              'Everything audio player does',
              'Fullscreen mode',
              'Picture-in-picture',
              'Quality settings (HD, 4K)',
              'Subtitles support',
            ],
          ),
          const SizedBox(height: 20),
          _buildSimpleFeatureCard(
            '📱 Smart Player',
            'One player for all media types',
            Colors.green,
            [
              'Auto-detects audio or video',
              'Playlist support',
              'Shuffle and repeat',
              'Beautiful themes',
              'Works on all devices',
            ],
          ),
        ],
      ),
    );
  }

  /// TAB 2: Shows how the player works with visual examples
  Widget _buildHowItWorksTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle('How Media Players Work'),
          const SizedBox(height: 20),
          _buildPlayerDemo(),
          const SizedBox(height: 30),
          _buildTitle('What Makes It Special'),
          const SizedBox(height: 20),
          _buildBenefitsList(),
        ],
      ),
    );
  }

  /// TAB 3: Shows simple code examples
  Widget _buildCodeExamplesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle('Easy to Use'),
          const SizedBox(height: 16),
          _buildSimpleCodeExample(
            'Audio Player',
            '''AudioPlayerWidget(
  audioUrl: 'my-song.mp3',
  title: 'My Favorite Song',
  artist: 'Cool Artist',
)''',
          ),
          const SizedBox(height: 20),
          _buildSimpleCodeExample(
            'Video Player',
            '''VideoPlayerWidget(
  videoUrl: 'my-video.mp4',
  title: 'My Video',
  allowFullScreen: true,
)''',
          ),
          const SizedBox(height: 20),
          _buildSimpleCodeExample(
            'Smart Player',
            '''UnifiedMediaPlayer(
  mediaUrl: 'any-media-file',
  mediaType: MediaType.audio,
  title: 'Any Media',
)''',
          ),
        ],
      ),
    );
  }

  /// Welcome card explaining what this demo shows
  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.withOpacity(0.8), Colors.blue.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome! 👋',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This demo shows you media player widgets that can play music and videos in your Flutter app.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '💡 Think of it like YouTube or Spotify player, but for your own app!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Simple feature card that's easy to read
  Widget _buildSimpleFeatureCard(String title, String description, Color color, List<String> features) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feature,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  /// Simple title widget
  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }

  /// Shows a visual example of how the player looks
  Widget _buildPlayerDemo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Song title
          const Text(
            '🎵 "My Favorite Song"',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'by Cool Artist',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          
          // Progress bar
          Row(
            children: [
              const Text('1:30', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text('3:45', style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 20),
          
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(Icons.replay_10, 'Skip Back'),
              _buildControlButton(Icons.pause, 'Pause', isPrimary: true),
              _buildControlButton(Icons.forward_10, 'Skip Forward'),
            ],
          ),
          const SizedBox(height: 20),
          
          // Volume control
          Row(
            children: [
              const Icon(Icons.volume_up, color: Colors.purple),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.7,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text('70%', style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  /// Control button helper
  Widget _buildControlButton(IconData icon, String tooltip, {bool isPrimary = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPrimary ? Colors.purple : Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isPrimary ? Colors.white : Colors.purple,
        size: isPrimary ? 24 : 20,
      ),
    );
  }

  /// List of benefits
  Widget _buildBenefitsList() {
    final benefits = [
      {
        'title': 'Easy to Use',
        'description': 'Just give it a music or video file and it works!',
        'icon': Icons.thumb_up,
      },
      {
        'title': 'Works Everywhere',
        'description': 'Android, iPhone, Web, and Desktop - all supported!',
        'icon': Icons.devices,
      },
      {
        'title': 'Looks Great',
        'description': 'Beautiful design that fits your app perfectly',
        'icon': Icons.palette,
      },
      {
        'title': 'Many Features',
        'description': 'Play, pause, volume, speed, playlists, and more',
        'icon': Icons.star,
      },
    ];

    return Column(
      children: benefits.map((benefit) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                benefit['icon'] as IconData,
                color: Colors.green,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    benefit['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    benefit['description'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  /// Simple code example
  Widget _buildSimpleCodeExample(String title, String code) {
    return Container(
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
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
