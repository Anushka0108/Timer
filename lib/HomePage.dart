import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? endTime;
  int selectedHours = 0;
  int selectedMinutes = 1;
  int selectedSeconds = 0;

  void startTimer() {
    final duration = Duration(
      hours: selectedHours,
      minutes: selectedMinutes,
      seconds: selectedSeconds,
    );

    if (duration.inSeconds > 0) {
      setState(() {
        endTime = DateTime.now().add(duration);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick a valid duration")),
      );
    }
  }

  void resetTimer() {
    setState(() {
      endTime = null;
      selectedHours = 0;
      selectedMinutes = 1;
      selectedSeconds = 0;
    });
  }

  Widget buildPicker({
    required int itemCount,
    required int initial,
    required ValueChanged<int> onSelectedItemChanged,
    required String unit,
  }) {
    return Expanded(
      child: CupertinoPicker(
        itemExtent: 40,
        scrollController: FixedExtentScrollController(initialItem: initial),
        onSelectedItemChanged: onSelectedItemChanged,
        children: List.generate(
          itemCount,
          (index) => Center(
            child: Text(
              "$index $unit",
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Countdown Timer"),
        backgroundColor: const Color.fromARGB(255, 80, 39, 152),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/backdrop.png"),fit: BoxFit.fitHeight)
        ),
        child: Center(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer, size: 60, color: Color.fromARGB(255, 80, 39, 152)),
                  const SizedBox(height: 20),
                  if (endTime == null) ...[
                    const Text(
                      "Pick Duration",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 150,
                      child: Row(
                        children: [
                          buildPicker(
                            itemCount: 24,
                            initial: selectedHours,
                            onSelectedItemChanged: (val) =>
                                setState(() => selectedHours = val),
                            unit: "h",
                          ),
                          buildPicker(
                            itemCount: 60,
                            initial: selectedMinutes,
                            onSelectedItemChanged: (val) =>
                                setState(() => selectedMinutes = val),
                            unit: "m",
                          ),
                          buildPicker(
                            itemCount: 60,
                            initial: selectedSeconds,
                            onSelectedItemChanged: (val) =>
                                setState(() => selectedSeconds = val),
                            unit: "s",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: startTimer,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("Start Timer"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 80, 39, 152),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ] else ...[
                    const Text(
                      "Time Remaining",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TimerCountdown(
                      format: CountDownTimerFormat.hoursMinutesSeconds,
                      endTime: endTime!,
                      onEnd: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("⏱ Time’s up!")),
                        );
                        resetTimer();
                      },
                      timeTextStyle: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton.icon(
                      onPressed: resetTimer,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Reset Timer"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
