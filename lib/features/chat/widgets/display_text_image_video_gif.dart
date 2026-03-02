import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:real_time_messaging_platform/common/enums/message_enum.dart';
import 'package:real_time_messaging_platform/features/chat/widgets/audio_player_item.dart';
import 'package:real_time_messaging_platform/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGif({
    super.key,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.audio
            ? AudioPlayerItem(message: message)
            : type == MessageEnum.video
                ? VideoPlayerItem(videoUrl: message)
                : type == MessageEnum.gif
                    ? Image.network(message)
                    : CachedNetworkImage(
                        imageUrl: message,
                      );
  }
}
