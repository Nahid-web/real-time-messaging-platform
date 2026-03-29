// ignore_for_file: public_member_api_docs, sort_constructors_first

class Call {
  final String callerId;
  final String callerName;
  final String callerPic;
  final String receiverId;
  final String receiverName;
  final String receiverPic;
  final String callId;
  final bool hasDialed;
  final bool hasVideo;

  Call({
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPic,
    required this.callId,
    required this.hasDialed,
    required this.hasVideo,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'callerId': callerId,
      'callerName': callerName,
      'callerPic': callerPic,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverPic': receiverPic,
      'callId': callId,
      'hasDialed': hasDialed,
      'hasVideo': hasVideo,
    };
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callerId: map['callerId'] as String,
      callerName: map['callerName'] as String,
      callerPic: map['callerPic'] as String,
      receiverId: map['receiverId'] as String,
      receiverName: map['receiverName'] as String,
      receiverPic: map['receiverPic'] as String,
      callId: map['callId'] as String,
      hasDialed: map['hasDialed'] as bool? ?? false,
      hasVideo: map['hasVideo'] as bool? ?? true, // Fallback to true if missing in old records
    );
  }
}
