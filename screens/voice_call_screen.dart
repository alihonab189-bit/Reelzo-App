import 'package:flutter/material.dart';
import '../services/voice_call_service.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class VoiceCallScreen extends StatefulWidget {
final String channel;

const VoiceCallScreen({super.key, required this.channel});

@override
State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {

RtcEngine? engine;

@override
void initState() {
super.initState();
startCall();
}

Future<void> startCall() async {
engine = await VoiceCallService.start(widget.channel);
}

@override
void dispose() {
if (engine != null) {
VoiceCallService.end(engine!);
}
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.black,
appBar: AppBar(title: const Text("Voice Call")),
body: Center(
child: GestureDetector(
onTap: () => Navigator.pop(context),
child: const CircleAvatar(
radius: 40,
backgroundColor: Colors.red,
child: Icon(Icons.call_end),
),
),
),
);
}
}