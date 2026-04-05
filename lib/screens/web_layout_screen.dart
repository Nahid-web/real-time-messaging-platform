import 'package:flutter/material.dart';
import 'package:real_time_messaging_platform/common/utils/colors.dart';
import 'package:real_time_messaging_platform/features/chat/widgets/contacts_list.dart';
import 'package:real_time_messaging_platform/features/status/screens/status_contacts_screen.dart';
import 'package:real_time_messaging_platform/widgets/web_profile_bar.dart';
import 'package:real_time_messaging_platform/widgets/web_search_bar.dart';

class WebLayoutScreen extends StatefulWidget {
  const WebLayoutScreen({super.key});

  @override
  State<WebLayoutScreen> createState() => _WebLayoutScreenState();
}

class _WebLayoutScreenState extends State<WebLayoutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left panel — fixed 360px width
          SizedBox(
            width: 360,
            child: Column(
              children: [
                const WebProfileBar(),
                const WebSearchBar(),
                TabBar(
                  controller: _tabController,
                  indicatorColor: tabColor,
                  indicatorWeight: 3,
                  labelColor: tabColor,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  tabs: const [
                    Tab(text: 'Messages'),
                    Tab(text: 'Stories'),
                    Tab(text: 'Calls'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      ContactsList(),
                      StatusContactsScreen(),
                      _WebCallsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Right panel — empty state (chat opens as a full route)
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: dividerColor),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/backgroundImage.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 80,
                      color: Colors.white24,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Select a conversation',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Choose a contact from the left to start chatting.',
                      style: TextStyle(color: Colors.white38, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WebCallsTab extends StatelessWidget {
  const _WebCallsTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.call_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No recent calls',
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          SizedBox(height: 8),
          Text(
            'Start a call from a chat by tapping\nthe call or video icon.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
