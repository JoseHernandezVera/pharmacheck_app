import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'home.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnim;

  late AnimationController _tickController;
  late Animation<double> _tickAnim;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _playedPart1 = false;
  bool _playedPart2 = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _scaleAnim = Tween<double>(begin: 0.3, end: 2.1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _tickController.forward();
        }
      });

    _tickController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _tickAnim = CurvedAnimation(parent: _tickController, curve: Curves.easeIn)
      ..addListener(_handleAudioPlayback);

    _scaleController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Home')),
        );
      }
    });
  }

  void _handleAudioPlayback() {
    final progress = _tickAnim.value;

    if (progress > 0.1 && !_playedPart1) {
      _playedPart1 = true;
      _audioPlayer.play(AssetSource('sounds/parte1.mp3'));
    }
    if (progress > 0.6 && !_playedPart2) {
      _playedPart2 = true;
      _audioPlayer.play(AssetSource('sounds/parte2.mp3'));
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _tickController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleController, _tickController]),
          builder: (_, __) {
            final progress = _tickAnim.value;

            return Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: _scaleAnim.value,
                  child: Image.asset(
                    'assets/images/logo_pildora.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                CustomPaint(
                  size: const Size(200, 350),
                  painter: _CheckPainter(progress),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  final double progress;

  _CheckPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.5)
      ..lineTo(size.width * 0.45, size.height * 0.7)
      ..lineTo(size.width * 1, size.height * 0.2);

    if (progress > 0.01) {
      final metric = path.computeMetrics().first;
      final extract = metric.extractPath(0.0, metric.length * progress);
      canvas.drawPath(extract, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CheckPainter old) =>
      old.progress != progress;
}