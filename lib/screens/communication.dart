import 'dart:io';
import 'package:finalyearproject/screens/time_management.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(VideoRecorderApp());
}

class VideoRecorderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Recorder & YouTube',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> options = [
    {'title': 'Record Your Skill', 'route': VideoListScreen()},
    {'title': 'Demo Class', 'route': YouTubeListScreen()},
    {'title': 'Listening Skill', 'route': _TimeManagementPageState()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Communication Page')),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(options[index]['title']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => options[index]['route'],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Video List Page
class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final List<File> _videoFiles = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedVideos = prefs.getStringList('video_paths');
    if (savedVideos != null) {
      setState(() {
        _videoFiles.addAll(savedVideos.map((path) => File(path)).toList());
      });
    }
  }

  Future<void> _saveVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> paths = _videoFiles.map((file) => file.path).toList();
    await prefs.setStringList('video_paths', paths);
  }

  Future<void> _recordVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      setState(() {
        _videoFiles.add(File(video.path));
      });
      _saveVideos();
    }
  }

  void _openVideoPlayer(File videoFile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoFile: videoFile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video List')),
      body: Column(
        children: [
          Expanded(
            child: _videoFiles.isEmpty
                ? Center(child: Text('No videos recorded yet'))
                : ListView.builder(
              itemCount: _videoFiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.video_library, color: Colors.blue),
                  title: Text('Video ${index + 1}'),
                  trailing: Icon(Icons.play_arrow, color: Colors.green),
                  onTap: () => _openVideoPlayer(_videoFiles[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: _recordVideo,
              child: Icon(Icons.videocam),
            ),
          ),
        ],
      ),
    );
  }
}

// Video Player Page
class VideoPlayerScreen extends StatefulWidget {
  final File videoFile;

  VideoPlayerScreen({required this.videoFile});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Player')),
      body: Center(
        child: _controller.value.isInitialized
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _togglePlayPause,
              child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            ),
          ],
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}

// YouTube List Page
class YouTubeListScreen extends StatelessWidget {
  final List<String> _youtubeVideos = [
    'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    'https://www.youtube.com/watch?v=3JZ_D3ELwOQ',
  ];

  void _openYouTubeVideo(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YouTubePlayerScreen(youtubeUrl: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo List')),
      body: ListView.builder(
        itemCount: _youtubeVideos.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.play_circle_fill, color: Colors.red),
            title: Text('Demo ${index + 1}'),
            onTap: () => _openYouTubeVideo(context, _youtubeVideos[index]),
          );
        },
      ),
    );
  }
}

// YouTube Player Page
class YouTubePlayerScreen extends StatefulWidget {
  final String youtubeUrl;

  YouTubePlayerScreen({required this.youtubeUrl});

  @override
  _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo Player')),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
      ),
    );
  }
}

class _TimeManagementPageState extends State<TimeManagementPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  final TextEditingController _textController = TextEditingController();

  final String predefinedPara =
      "Rahul was a manager at a big company One day,a client complained about a mistake in a report Frustrated, Rahul stormed into the office and yelled at his team The atmosphere became tense, and everyone felt demotivated A young intern,Aisha, observed the situation Instead of reacting with fear, she calmly approached Rahul and said,I understand this is stressful Lets take a deep breath and find a solution together Rahul paused He realized he had let his anger take control Instead of blaming his team, he focused on fixing the mistake The team felt relieved, and they worked together efficiently Later that day,Rahul thanked Aisha You helped me realize that staying calm and understanding emotions can solve problems better than anger From that day on,Rahul practiced emotional intelligence controlling his reactions, understanding his teams emotions, and fostering a positive work environment";


  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  void _toggleMusic() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource('Audio/Audio1.mp3')); // Corrected path
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _seekAudio(Duration position) {
    _audioPlayer.seek(position);
  }

  void _checkTextMatch() {
    String inputText = _textController.text.trim();

    if (inputText.isEmpty) {
      _showAlert("Alert", "Please fill in your thoughts.");
      return;
    }

    if (inputText == predefinedPara) {
      _showAlert("Eligible", "Your input is an exact match.");
    } else if (_checkSimilarity(inputText, predefinedPara)) {
      _showAlert("OK", "Your input has similar words.");
    } else {
      _showAlert("Not Eligible", "Your input does not match.");
    }
  }

  bool _checkSimilarity(String input, String original) {
    List<String> inputWords = input.toLowerCase().split(' ');
    List<String> originalWords = original.toLowerCase().split(' ');

    int matchCount = inputWords.where((word) => originalWords.contains(word)).length;
    return matchCount >= (originalWords.length * 0.6);
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Management"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Play/Pause Button
            ElevatedButton(
              onPressed: _toggleMusic,
              child: Text(isPlaying ? "Pause Music" : "Play Music"),
            ),
            SizedBox(height: 10),

            // Audio Progress Bar
            Slider(
              min: 0,
              max: _duration.inSeconds.toDouble(),
              value: _position.inSeconds.toDouble(),
              onChanged: (value) {
                _seekAudio(Duration(seconds: value.toInt()));
              },
            ),

            // Duration Text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_position)),
                Text(_formatDuration(_duration)),
              ],
            ),

            SizedBox(height: 20),

            // Text Input Field
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Type the given paragraph...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Check Eligibility Button
            ElevatedButton(
              onPressed: _checkTextMatch,
              child: Text("Check Eligibility"),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}