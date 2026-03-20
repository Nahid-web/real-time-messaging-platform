import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:real_time_messaging_platform/features/call/controller/call_controller.dart';
import 'package:real_time_messaging_platform/models/call.dart';

class CallScreen extends ConsumerStatefulWidget {
  static const routeName = '/call-screen';

  final String channelId;
  final Call call;
  final bool isGroupChat;

  const CallScreen({
    super.key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  });

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  RtcEngine? _engine;
  bool _isJoined = false;
  int? _remoteUid;
  bool _isMuted = false;
  bool _isCameraOff = false;

  @override
  void initState() {
    super.initState();
    _setupAgora();
  }

  Future<String> _fetchToken() async {
    final serverUrl = dotenv.env['serverBaseUrl'] ?? '';
    if (serverUrl.isEmpty) return '';

    try {
      final uri = Uri.parse(
        '$serverUrl/generate-token?channelName=${widget.channelId}&uid=0',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'] as String? ?? '';
      }
    } catch (e) {
      debugPrint('Token server error: $e — falling back to empty token');
    }
    return '';
  }

  Future<void> _setupAgora() async {
    // Skip on web — Agora video SDK does not have full web support
    if (kIsWeb) return;

    final appId = dotenv.env['agoraAppId'] ?? '';
    if (appId.isEmpty) return;

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(appId: appId));

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() => _isJoined = true);
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          setState(() => _remoteUid = remoteUid);
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() => _remoteUid = null);
          _endCall();
        },
        onLeaveChannel: (connection, stats) {
          setState(() {
            _isJoined = false;
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine!.enableVideo();
    await _engine!.enableAudio();
    await _engine!.startPreview();

    // Fetch token from backend server (falls back to empty = testing mode)
    final token = await _fetchToken();

    await _engine!.joinChannel(
      token: token,
      channelId: widget.channelId,
      uid: 0,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> _endCall() async {
    await _engine?.leaveChannel();
    await _engine?.release();
    if (mounted) {
      ref.read(callControllerProvider).endCall(
            widget.call.callerId,
            widget.call.receiverId,
            context,
          );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  Widget _remoteVideo() {
    if (kIsWeb) {
      return const Center(
        child: Text(
          'Video calls are not supported on web.',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine!,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelId),
        ),
      );
    }
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(widget.call.receiverPic),
            ),
            const SizedBox(height: 16),
            Text(
              widget.call.receiverName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Calling...',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Remote video (full screen)
            Positioned.fill(child: _remoteVideo()),

            // Local video (Picture-in-Picture top-right)
            if (!kIsWeb && _isJoined && !_isCameraOff)
              Positioned(
                top: 16,
                right: 16,
                width: 100,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine!,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),
                ),
              ),

            // Caller info header (top-left)
            Positioned(
              top: 16,
              left: 16,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      FirebaseAuth.instance.currentUser!.uid ==
                              widget.call.callerId
                          ? widget.call.callerPic
                          : widget.call.receiverPic,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    FirebaseAuth.instance.currentUser!.uid ==
                            widget.call.callerId
                        ? widget.call.callerName
                        : widget.call.receiverName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                ],
              ),
            ),

            // Controls bar at bottom
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Mute mic
                  _ControlButton(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    color: _isMuted ? Colors.white : Colors.white,
                    background:
                        _isMuted ? Colors.red.shade400 : Colors.white24,
                    onTap: () async {
                      setState(() => _isMuted = !_isMuted);
                      await _engine?.muteLocalAudioStream(_isMuted);
                    },
                  ),

                  // End call
                  _ControlButton(
                    icon: Icons.call_end,
                    color: Colors.white,
                    background: Colors.red,
                    size: 64,
                    onTap: _endCall,
                  ),

                  // Camera toggle
                  _ControlButton(
                    icon: _isCameraOff
                        ? Icons.videocam_off
                        : Icons.videocam,
                    color: Colors.white,
                    background:
                        _isCameraOff ? Colors.red.shade400 : Colors.white24,
                    onTap: () async {
                      setState(() => _isCameraOff = !_isCameraOff);
                      await _engine?.muteLocalVideoStream(_isCameraOff);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color background;
  final double size;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Icon(icon, color: color, size: size * 0.45),
      ),
    );
  }
}
