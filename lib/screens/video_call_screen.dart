import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/agora_service.dart';

class VideoCallScreen extends StatefulWidget {
final String channel;

const VideoCallScreen({super.key, required this.channel});

@override
State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {

RtcEngine? engine;
int? remoteUid;

@override
void initState() {
super.initState();
initCall();
}

Future<void> initCall() async {

await [Permission.camera, Permission.microphone].request();

engine = await AgoraService.initEngine();

engine!.registerEventHandler(
  RtcEngineEventHandler(
    onUserJoined: (connection, uid, elapsed) {
      setState(() => remoteUid = uid);
    },
    onUserOffline: (connection, uid, reason) {
      setState(() => remoteUid = null);
    },
  ),
);

await engine!.enableVideo();
await engine!.startPreview();

await engine!.joinChannel(
  token: "",
  channelId: widget.channel,
  uid: 0,
  options: const ChannelMediaOptions(),
);

}

@override
void dispose() {
engine?.leaveChannel();
engine?.release();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.black,
body: Stack(
children: [

      // 🔥 REMOTE VIDEO
      if (remoteUid != null)
        AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: engine!,
            canvas: VideoCanvas(uid: remoteUid),
            connection: RtcConnection(channelId: widget.channel),
          ),
        )
      else
        const Center(
          child: Text("Waiting...", style: TextStyle(color: Colors.white)),
        ),

      // 📱 LOCAL VIDEO
      Positioned(
        top: 50,
        right: 20,
        child: SizedBox(
          width: 120,
          height: 160,
          child: AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: engine!,
              canvas: const VideoCanvas(uid: 0),
            ),
          ),
        ),
      ),

      // ❌ END CALL
      Positioned(
        bottom: 50,
        left: 0,
        right: 0,
        child: Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.red,
              child: Icon(Icons.call_end),
            ),
          ),
        ),
      ),
    ],
  ),
);

}
}