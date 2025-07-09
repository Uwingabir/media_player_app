# Flutter Media Player Widgets

A comprehensive collection of professional-grade audio and video player widgets for Flutter applications, featuring all the core components you need for modern media playback.

## 🎵 Features

### Audio Player Widget
- **Playback Controls**: Play, pause, stop, skip forward/backward (10s)
- **Progress Management**: Scrubable timeline with current position and duration
- **Audio Controls**: Volume slider, mute toggle, and playback speed adjustment
- **Beautiful UI**: Modern design with gradients and smooth animations
- **Loading States**: Elegant loading indicators and error handling

### Video Player Widget
- **All Audio Features**: Complete audio functionality built-in
- **Video Display**: Responsive video player with aspect ratio management
- **Fullscreen Mode**: Toggle fullscreen with system UI management
- **Picture-in-Picture**: Support for PiP mode (platform dependent)
- **Quality Selection**: Choose between different video qualities
- **Speed Control**: Playback speed from 0.25x to 2.0x
- **Subtitle Support**: Ready for subtitle/caption integration
- **Error Recovery**: Robust error handling with retry functionality

### Unified Media Player
- **Single Interface**: One widget handles both audio and video
- **Playlist Support**: Navigate through multiple media items
- **Media Type Detection**: Automatically adapts UI based on content type
- **Consistent Theming**: Unified design across all media types
- **Dynamic Switching**: Seamless transition between audio and video

### Advanced Features
- **Shuffle Mode**: Random playback order
- **Repeat Modes**: None, All, One track repeat
- **Favorites**: Like/favorite media items
- **Share Functionality**: Share media content
- **Custom Themes**: Fully customizable color schemes
- **Accessibility**: Keyboard navigation and screen reader support

## 🚀 Quick Start

### Installation

Add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  video_player: ^2.8.1
  audioplayers: ^5.2.1
  chewie: ^1.7.5
  just_audio: ^0.9.36
```

### Basic Usage

#### Audio Player
```dart
import 'package:audioplayer/widgets/audio_player_widget.dart';

AudioPlayerWidget(
  audioUrl: 'https://example.com/audio.mp3',
  title: 'My Audio Track',
  artist: 'Artist Name',
  primaryColor: Colors.blue,
)
```

#### Video Player
```dart
import 'package:audioplayer/widgets/video_player_widget.dart';

VideoPlayerWidget(
  videoUrl: 'https://example.com/video.mp4',
  title: 'My Video',
  allowFullScreen: true,
  primaryColor: Colors.red,
)
```

#### Unified Player
```dart
import 'package:audioplayer/widgets/unified_media_player.dart';

UnifiedMediaPlayer(
  mediaUrl: 'https://example.com/media.mp3',
  mediaType: MediaType.audio,
  title: 'Media Title',
  primaryColor: Colors.purple,
  playlist: [
    MediaItem(
      url: 'https://example.com/audio1.mp3',
      type: MediaType.audio,
      title: 'Track 1',
    ),
    MediaItem(
      url: 'https://example.com/video1.mp4',
      type: MediaType.video,
      title: 'Video 1',
    ),
  ],
)
```

## 📱 Demo

Run the demo app to see all widgets in action:

```bash
flutter run
```

The demo includes:
- **Audio Player Tab**: Basic and themed audio players
- **Video Player Tab**: Video playback with all controls
- **Unified Player Tab**: Mixed media playlist
- **Advanced Tab**: Full-featured player with all options

## 🎨 Customization

### Theming
All widgets support custom color schemes:

```dart
AudioPlayerWidget(
  audioUrl: 'your-audio-url',
  primaryColor: Colors.teal, // Custom theme color
  title: 'Custom Themed Player',
)
```

### Advanced Configuration
```dart
AdvancedUnifiedMediaPlayer(
  playlist: myPlaylist,
  primaryColor: Colors.purple,
  enableShuffle: true,
  enableRepeat: true,
  onMediaChanged: (index) {
    print('Playing media at index: $index');
  },
  onMediaFavorited: (media) {
    // Handle favorite action
  },
)
```

## 🔧 Technical Details

### Architecture
- **Modular Design**: Separate widgets for different use cases
- **State Management**: Efficient state handling with StatefulWidget
- **Plugin Integration**: Seamless integration with Flutter media plugins
- **Performance**: Optimized for smooth playback and minimal resource usage

### Supported Formats
- **Audio**: MP3, WAV, AAC, OGG, FLAC
- **Video**: MP4, WebM, AVI, MOV
- **Streaming**: HTTP/HTTPS URLs, local files

### Platform Support
- ✅ iOS
- ✅ Android
- ✅ Web
- ✅ Desktop (Windows, macOS, Linux)

## 📖 API Reference

### AudioPlayerWidget

| Parameter | Type | Description |
|-----------|------|-------------|
| `audioUrl` | `String` | URL or path to audio file |
| `title` | `String?` | Display title |
| `artist` | `String?` | Artist name |
| `primaryColor` | `Color?` | Theme color |
| `showPlaylist` | `bool` | Show playlist controls |

### VideoPlayerWidget

| Parameter | Type | Description |
|-----------|------|-------------|
| `videoUrl` | `String` | URL or path to video file |
| `title` | `String?` | Display title |
| `allowFullScreen` | `bool` | Enable fullscreen mode |
| `allowPictureInPicture` | `bool` | Enable PiP mode |
| `aspectRatio` | `double` | Video aspect ratio |
| `primaryColor` | `Color?` | Theme color |

### UnifiedMediaPlayer

| Parameter | Type | Description |
|-----------|------|-------------|
| `mediaUrl` | `String` | URL or path to media file |
| `mediaType` | `MediaType` | Audio or video type |
| `playlist` | `List<MediaItem>?` | Playlist items |
| `onMediaChanged` | `Function(int)?` | Media change callback |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [just_audio](https://pub.dev/packages/just_audio) - Audio playback
- [video_player](https://pub.dev/packages/video_player) - Video playback
- [chewie](https://pub.dev/packages/chewie) - Video player UI
- [audioplayers](https://pub.dev/packages/audioplayers) - Audio support

## 📞 Support

For support, please open an issue on GitHub or contact the development team.

---

Made with ❤️ for the Flutter community
