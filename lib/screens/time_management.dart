import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class TimeManagementPage extends StatefulWidget {
  @override
  _TimeManagementPageState createState() => _TimeManagementPageState();
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
