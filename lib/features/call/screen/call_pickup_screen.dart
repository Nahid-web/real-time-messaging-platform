import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_time_messaging_platform/features/call/controller/call_controller.dart';
import 'package:real_time_messaging_platform/features/call/screen/call_screen.dart';
import 'package:real_time_messaging_platform/models/call.dart';

class CallPickupScreen extends ConsumerWidget {
  final Widget scaffold;

  const CallPickupScreen({super.key, required this.scaffold});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: ref.watch(callControllerProvider).callStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          Call call =
              Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          if (!call.hasDialed && FirebaseAuth.instance.currentUser!.uid == call.receiverId) {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Incoming Call',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(call.callerPic),
                      radius: 60,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      call.callerName,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 75,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              ref.read(callControllerProvider).endCall(
                                    call.callerId,
                                    call.receiverId,
                                    context,
                                  );
                            },
                            icon: const Icon(
                              Icons.call_end,
                              color: Colors.redAccent,
                            )),
                        const SizedBox(
                          width: 25,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CallScreen(
                                    channelId: call.callId,
                                    call: call,
                                    isGroupChat: false,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.call,
                              color: Colors.green,
                            ))
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        }
        return scaffold;
      },
    );
  }
}
