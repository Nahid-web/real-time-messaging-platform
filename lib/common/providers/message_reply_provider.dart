import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_time_messaging_platform/common/enums/message_enum.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply(
      {required this.message, required this.isMe, required this.messageEnum});
}

class MessageReplyNotifier extends Notifier<MessageReply?> {
  @override
  MessageReply? build() => null;

  void set(MessageReply? value) => state = value;
}

final messageReplyProvider = NotifierProvider<MessageReplyNotifier, MessageReply?>(
  MessageReplyNotifier.new,
);
