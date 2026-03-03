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
    return Scaffold(
      body: storyItems.isEmpty
          ? const Loader()
          : Stack(
              children: [
                StoryView(
                  storyItems: storyItems,
                  controller: controller,
                  repeat: false,
                  onComplete: () {
                    Navigator.pop(context);
                  },
                  onVerticalSwipeComplete: (p0) {
                    if (p0 == Direction.down) {
                      Navigator.pop(context);
                    }
                  },
                ),
                Positioned(
                  top: 50,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.status.profilePic),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.status.username,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
