import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:real_time_messaging_platform/features/auth/controller/auth_controller.dart';
import 'package:real_time_messaging_platform/features/call/repository/call_repository.dart';
import 'package:real_time_messaging_platform/models/call.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(
    callRepository: callRepository,
    ref: ref,
    auth: FirebaseAuth.instance,
  );
});

class CallController {
  final CallRepository callRepository;
  final Ref ref;
  final FirebaseAuth auth;

  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });
  Stream<DocumentSnapshot> get callStream => callRepository.callStream;
  void makeCall(
    BuildContext context,
    String receiverName,
    String receiverUid,
    String receiverProfilePic,
    bool isGroupChat,
    bool hasVideo,
  ) {
    ref.read(userDataAuthProvider).whenData(
      (value) {
        String callId = const Uuid().v1();
        Call senderCallData = Call(
          callerId: auth.currentUser!.uid,
          callerName: value!.name,
          callerPic: value.profilePic,
          receiverId: receiverUid,
          receiverName: receiverName,
          receiverPic: receiverProfilePic,
          callId: callId,
          hasDialed: true,
          hasVideo: hasVideo,
        );
        Call receiverCallData = Call(
          callerId: auth.currentUser!.uid,
          callerName: value.name,
          callerPic: value.profilePic,
          receiverId: receiverUid,
          receiverName: receiverName,
          receiverPic: receiverProfilePic,
          callId: callId,
          hasDialed: false,
          hasVideo: hasVideo,
        );

        callRepository.makeCall(
          senderCallData,
          context,
          receiverCallData,
        );
      },
    );
  }

  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) {
    callRepository.endCall(
      callerId,
      receiverId,
      context,
    );
  }
}
