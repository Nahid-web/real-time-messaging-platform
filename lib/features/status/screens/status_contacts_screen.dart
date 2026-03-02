import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_time_messaging_platform/common/utils/colors.dart';
import 'package:real_time_messaging_platform/common/widgets/loader.dart';
import 'package:real_time_messaging_platform/features/status/controller/status_controller.dart';
import 'package:real_time_messaging_platform/features/status/screens/status_screen.dart';
import 'package:real_time_messaging_platform/models/status_model.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({super.key});

  void viewStatus(BuildContext context, Status statusData) {
    Navigator.pushNamed(
      context,
      StatusScreen.routeName,
      arguments: statusData,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Status>>(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var statusData = snapshot.data![index];
            return Column(
              children: [
                InkWell(
                  onTap: () => viewStatus(context, statusData),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        statusData.username,
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          statusData.profilePic,
                        ),
                        radius: 30,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: dividerColor,
                  indent: 85,
                )
              ],
            );
          },
        );
      },
    );
  }
}
