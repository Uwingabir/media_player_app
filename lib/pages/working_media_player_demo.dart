import 'package:flutter/material.dart';
import '../widgets/audio_player_widget.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/media_library_manager.dart';

class WorkingMediaPlayerDemo extends StatefulWidget {
  const WorkingMediaPlayerDemo({super.key});

  @override
  State<WorkingMediaPlayerDemo> createState() => _WorkingMediaPlayerDemoState();
}

class _WorkingMediaPlayerDemoState extends State<WorkingMediaPlayerDemo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MediaLibraryManager _libraryManager = MediaLibraryManager();

  // Working sample media URLs
  final List<MediaItem> _sampleMedia = [
    MediaItem(
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      type: MediaType.audio,
      title: 'SoundHelix Song 1',
      artist: 'SoundHelix',
      duration: const Duration(minutes: 4, seconds: 33),
    ),
    MediaItem(
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      type: MediaType.audio,
      title: 'SoundHelix Song 2',
      artist: 'SoundHelix',
      duration: const Duration(minutes: 3, seconds: 47),
    ),
    MediaItem(
      url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      type: MediaType.video,
      title: 'Big Buck Bunny',
      artist: 'Blender Foundation',
      duration: const Duration(minutes: 9, seconds: 56),
    ),
    MediaItem(
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      type: MediaType.audio,
      title: 'SoundHelix Song 3',
      artist: 'SoundHelix',
      duration: const Duration(minutes: 5, seconds: 12),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Create some default playlists
    _libraryManager.createPlaylist('My Favorites');
    _libraryManager.createPlaylist('Chill Music');
    _libraryManager.createPlaylist('Videos');
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
          '🎵 Working Media Players',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.music_note), text: 'Audio'),
            Tab(icon: Icon(Icons.video_library), text: 'Video'),
            Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
            Tab(icon: Icon(Icons.playlist_play), text: 'Playlists'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAudioTab(),
          _buildVideoTab(),
          _buildFavoritesTab(),
          _buildPlaylistsTab(),
        ],
      ),
    );
  }

  Widget _buildAudioTab() {
    final audioItems = _sampleMedia.where((item) => item.type == MediaType.audio).toList();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: audioItems.length,
      itemBuilder: (context, index) {
        final item = audioItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: ListenableBuilder(
            listenable: _libraryManager,
            builder: (context, child) {
              return AudioPlayerWidget(
                audioUrl: item.url,
                title: item.title,
                artist: item.artist,
                primaryColor: Colors.purple,
                isFavorite: _libraryManager.isFavorite(item.url),
                onAddToFavorites: (url) {
                  _libraryManager.toggleFavorite(item);
                },
                onAddToPlaylist: (url) {
                  _showPlaylistSelector(item);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildVideoTab() {
    final videoItems = _sampleMedia.where((item) => item.type == MediaType.video).toList();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: videoItems.length,
      itemBuilder: (context, index) {
        final item = videoItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: ListenableBuilder(
            listenable: _libraryManager,
            builder: (context, child) {
              return VideoPlayerWidget(
                videoUrl: item.url,
                title: item.title,
                primaryColor: Colors.red,
                isFavorite: _libraryManager.isFavorite(item.url),
                onAddToFavorites: (url) {
                  _libraryManager.toggleFavorite(item);
                },
                onAddToPlaylist: (url) {
                  _showPlaylistSelector(item);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFavoritesTab() {
    return ListenableBuilder(
      listenable: _libraryManager,
      builder: (context, child) {
        final favorites = _libraryManager.favorites;
        
        if (favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the heart icon on any audio or video to add it to favorites',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final item = favorites[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: item.type == MediaType.audio ? Colors.purple : Colors.red,
                  child: Icon(
                    item.type == MediaType.audio ? Icons.music_note : Icons.video_library,
                    color: Colors.white,
                  ),
                ),
                title: Text(item.title),
                subtitle: Text(item.artist ?? 'Unknown Artist'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.playlist_add, color: Colors.blue),
                      onPressed: () => _showPlaylistSelector(item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => _libraryManager.removeFromFavorites(item.url),
                    ),
                  ],
                ),
                onTap: () => _playMedia(item),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPlaylistsTab() {
    return ListenableBuilder(
      listenable: _libraryManager,
      builder: (context, child) {
        final playlists = _libraryManager.playlists;
        
        return Column(
          children: [
            // Add new playlist button
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _showCreatePlaylistDialog,
                icon: const Icon(Icons.add),
                label: const Text('Create New Playlist'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            
            // Playlists list
            Expanded(
              child: playlists.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.playlist_play,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No playlists yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create a playlist to organize your media',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: playlists.length,
                      itemBuilder: (context, index) {
                        final playlist = playlists[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ExpansionTile(
                            leading: const Icon(Icons.playlist_play, color: Colors.deepPurple),
                            title: Text(
                              playlist.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('${playlist.itemCount} items'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDeletePlaylist(playlist.name),
                            ),
                            children: [
                              if (playlist.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'This playlist is empty. Add some media to get started!',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              else
                                ...playlist.items.map((item) => ListTile(
                                  leading: Icon(
                                    item.type == MediaType.audio 
                                        ? Icons.music_note 
                                        : Icons.video_library,
                                    color: item.type == MediaType.audio 
                                        ? Colors.purple 
                                        : Colors.red,
                                  ),
                                  title: Text(item.title),
                                  subtitle: Text(item.artist ?? 'Unknown Artist'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                                    onPressed: () => _libraryManager.removeFromPlaylist(
                                      playlist.name, 
                                      item.url,
                                    ),
                                  ),
                                  onTap: () => _playMedia(item),
                                )),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  void _showPlaylistSelector(MediaItem item) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add to Playlist',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._libraryManager.playlists.map((playlist) => ListTile(
              leading: const Icon(Icons.playlist_play),
              title: Text(playlist.name),
              subtitle: Text('${playlist.itemCount} items'),
              onTap: () {
                _libraryManager.addToPlaylist(playlist.name, item);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added "${item.title}" to "${playlist.name}"'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            )),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _showCreatePlaylistDialog(mediaItem: item);
              },
              icon: const Icon(Icons.add),
              label: const Text('Create New Playlist'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog({MediaItem? mediaItem}) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Playlist'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Playlist name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                _libraryManager.createPlaylist(controller.text.trim());
                if (mediaItem != null) {
                  _libraryManager.addToPlaylist(controller.text.trim(), mediaItem);
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Created playlist "${controller.text.trim()}"'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _confirmDeletePlaylist(String playlistName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Playlist'),
        content: Text('Are you sure you want to delete "$playlistName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _libraryManager.deletePlaylist(playlistName);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted playlist "$playlistName"'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _playMedia(MediaItem item) {
    // Switch to appropriate tab and scroll to item
    if (item.type == MediaType.audio) {
      _tabController.animateTo(0);
    } else {
      _tabController.animateTo(1);
    }
  }
}
