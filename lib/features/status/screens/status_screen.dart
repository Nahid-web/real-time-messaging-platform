import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:real_time_messaging_platform/common/widgets/loader.dart';
import 'package:real_time_messaging_platform/models/status_model.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/status-screen';
  final Status status;
  const StatusScreen({super.key, required this.status});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initStoryPageItems();
  }

  void initStoryPageItems() {
    for (var i = 0; i < widget.status.photoUrl.length; i++) {
      storyItems.add(
        StoryItem.pageImage(
            url: widget.status.photoUrl[i], controller: controller),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return storyItems.isEmpty
        ? const Loader()
        : StoryView(
            storyItems: storyItems,
            controller: controller,
            repeat: true,
            onVerticalSwipeComplete: (p0) {
              if (p0 == Direction.down) {
                Navigator.pop(context);
              }
            },
          );
  }
}
