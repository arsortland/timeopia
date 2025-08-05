import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:ui';
import '../services/music_service.dart';

class Timerpage extends StatefulWidget {
  const Timerpage({super.key});

  @override
  State<Timerpage> createState() => _TimerpageState();
}

class _TimerpageState extends State<Timerpage> with WidgetsBindingObserver {
  Timer? _timer;
  int _seconds = 25; // 3 seconds for testing
  bool _isRunning = false;
  bool _isBreakTime = false;
  int _completedPomodoros = 0;
  bool _isAppInBackground = false;
  Timer? _backgroundTimer;

  // Notification plugin
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Pomodoro settings
  static const int _pomodoroTime = 3; // 3 seconds for testing
  static const int _shortBreakTime = 3; // 3 seconds for testing
  static const int _longBreakTime = 3; // 3 seconds for testing

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _backgroundTimer?.cancel();
    super.dispose();
  }

  // Initialize notifications
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  // Handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        // App is in background or minimized
        if (_isRunning && !_isBreakTime) {
          _handleAppBackground();
        }
        break;
      case AppLifecycleState.resumed:
        // App is back in foreground
        _handleAppForeground();
        break;
      case AppLifecycleState.hidden:
        // App is hidden but still running
        if (_isRunning && !_isBreakTime) {
          _handleAppBackground();
        }
        break;
    }
  }

  void _handleAppBackground() {
    setState(() {
      _isAppInBackground = true;
    });

    // Start sending focus reminders every 10 seconds
    _backgroundTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _showFocusReminder();
    });

    // Show immediate notification
    _showFocusReminder();
  }

  void _handleAppForeground() {
    setState(() {
      _isAppInBackground = false;
    });

    _backgroundTimer?.cancel();
    _backgroundTimer = null;

    // Cancel any pending notifications
    _notificationsPlugin.cancelAll();

    // Show welcome back message if user was focusing
    if (_isRunning && !_isBreakTime) {
      _showWelcomeBackDialog();
    }
  }

  Future<void> _showFocusReminder() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'focus_channel',
          'Focus Reminders',
          channelDescription: 'Notifications to remind you to stay focused',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: false,
          ongoing: true,
          autoCancel: false,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    String message = _isBreakTime
        ? 'Break time! Relax and recharge 😌'
        : 'Stay focused! Your pomodoro is running 🍅';

    String timeLeft = 'Time left: $_formattedTime';

    await _notificationsPlugin.show(
      0,
      'Timeopia - Focus Session',
      '$message\n$timeLeft',
      platformChannelSpecifics,
    );
  }

  void _showWelcomeBackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Welcome Back! 👋'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.smartphone, size: 48, color: Colors.orange),
            const SizedBox(height: 16),
            const Text('You left during your focus session.'),
            const SizedBox(height: 8),
            Text('Time remaining: $_formattedTime'),
            const SizedBox(height: 16),
            const Text(
              'Remember: Focus is key to productivity! 💪',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Continue Focus'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _stopTimer();
            },
            child: const Text('Pause'),
          ),
        ],
      ),
    );
  }

  // Convert seconds to MM:SS format
  String get _formattedTime {
    int minutes = _seconds ~/ 60;
    int remainingSeconds = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String get _currentPhase {
    if (_isBreakTime) {
      return _completedPomodoros % 4 == 0 && _completedPomodoros > 0
          ? 'Long Break'
          : 'Short Break';
    }
    return 'Focus Time';
  }

  Color get _phaseColor {
    if (_isBreakTime) {
      return _completedPomodoros % 4 == 0 && _completedPomodoros > 0
          ? Colors.purple
          : Colors.green;
    }
    return Colors.red;
  }

  void _startTimer() {
    if (_timer != null) return;

    setState(() {
      _isRunning = true;
    });

    // Stop background music when timer starts
    MusicService.setTimerActive(true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;

          // Update notification if app is in background
          if (_isAppInBackground) {
            _showFocusReminder();
          }
        } else {
          _stopTimer();
          _onTimerComplete();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _backgroundTimer?.cancel();
    _backgroundTimer = null;
    _notificationsPlugin.cancelAll();

    setState(() {
      _isRunning = false;
      _isAppInBackground = false;
    });

    // Resume background music when timer stops
    MusicService.setTimerActive(false);
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _seconds = _pomodoroTime;
      _isBreakTime = false;
      _completedPomodoros = 0;
    });
  }

  void _onTimerComplete() {
    // Cancel background notifications when timer completes
    _notificationsPlugin.cancelAll();

    if (_isBreakTime) {
      // Break is over, start new Pomodoro
      setState(() {
        _isBreakTime = false;
        _seconds = _pomodoroTime;
      });
      _showPhaseDialog('Break Complete!', 'Time to focus again!', Colors.red);
    } else {
      // Pomodoro complete, start break
      setState(() {
        _completedPomodoros++;
        _isBreakTime = true;

        // Long break after every 4 pomodoros
        if (_completedPomodoros % 4 == 0) {
          _seconds = _longBreakTime;
          _showPhaseDialog(
            'Pomodoro Complete!',
            'Take a long break!',
            Colors.purple,
          );
        } else {
          _seconds = _shortBreakTime;
          _showPhaseDialog(
            'Pomodoro Complete!',
            'Take a short break!',
            Colors.green,
          );
        }
      });
    }
  }

  void _showPhaseDialog(String title, String message, Color color) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyle(color: color)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isBreakTime ? Icons.coffee : Icons.work,
              size: 48,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(message),
            if (_completedPomodoros > 0) ...[
              const SizedBox(height: 16),
              Text(
                'Completed Pomodoros: $_completedPomodoros',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startTimer(); // Auto-start next phase
            },
            child: const Text('Start'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background layer with reduced blur effect
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background/background2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3), // Reduced white overlay
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10.0,
                    sigmaY: 10.0,
                  ), // Reduced blur
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                ),
              ),
            ),
          ),
          // Music toggle button
          Positioned(
            top: 40,
            right: 16,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      MusicService.toggleMusic();
                    });
                  },
                  icon: Icon(
                    MusicService.isMusicEnabled
                        ? Icons.music_note
                        : Icons.music_off,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Status Indicator
                  if (_isAppInBackground) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Focus mode: Stay in the app!',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Phase Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: _phaseColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: _phaseColor, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isBreakTime ? Icons.coffee : Icons.work,
                          color: _phaseColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _currentPhase,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _phaseColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Pomodoro Counter
                  if (_completedPomodoros > 0) ...[
                    Text(
                      'Completed: $_completedPomodoros 🍅',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Timer Display
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      border: Border.all(color: _phaseColor, width: 3),
                      borderRadius: BorderRadius.circular(20),
                      color: _phaseColor.withOpacity(0.1),
                    ),
                    child: Text(
                      _formattedTime,
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: _phaseColor,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Control Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isRunning ? _stopTimer : _startTimer,
                        icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                        label: Text(_isRunning ? 'Pause' : 'Start'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRunning
                              ? Colors.orange
                              : _phaseColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _resetTimer,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ], // Close Stack children
      ),
    );
  }
}
