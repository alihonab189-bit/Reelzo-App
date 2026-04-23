import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../services/live_service.dart';

class LiveScreen extends StatefulWidget {
const LiveScreen({super.key});

@override
State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {

late RtcEngine engine;

@override
void initState() {
super.initState();
initLive();
}

Future<void> initLive() async {
engine = createAgoraRtcEngine();
await engine.initialize(const RtcEngineContext(appId: LiveService.appId));

await engine.enableVideo();
await engine.startPreview();

await engine.joinChannel(
  token: "",
  channelId: "reelzo_live",
  uid: 0,
  options: const ChannelMediaOptions(),
);

}

@override
void dispose() {
engine.leaveChannel();
engine.release();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.black,
body: Stack(
children: [

      /// 🎥 VIDEO
      const Center(child: Text("Live Video", style: TextStyle(color: Colors.white))),

      /// ❌ END BUTTON
      Positioned(
        top: 40,
        right: 20,
        child: IconButton(
          icon: const Icon(Icons.call_end, color: Colors.red),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

    ],
  ),
);

}
}