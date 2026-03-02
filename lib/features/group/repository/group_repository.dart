import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:real_time_messaging_platform/common/repositories/common_storage_repository.dart';
import 'package:real_time_messaging_platform/common/utils/utils.dart';
import 'package:real_time_messaging_platform/models/group_model.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final Ref ref;

  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(
    BuildContext context,
    String groupName,
    File groupProPic,
    List<Contact> selectedContact,
  ) async {
    try {
      List<String> uids = [];

      for (var i = 0; i < selectedContact.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where('phoneNumber',
                isEqualTo: selectedContact[i]
                    .phones[0]
                    .number
                    .replaceAll(
                      ' ',
                      '',
                    )
                    .replaceAll('-', ''))
            .get();

        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }
      var groupId = const Uuid().v1();

      String groupProUrl = await ref
          .read(commonCloudinryStorageRepository)
          .storeFileToCloundinry(
            'whatsAppClone/group',
            groupId,
            groupProPic,
          );

      GroupModel groupModel = GroupModel(
        senderId: auth.currentUser!.uid,
        groupName: groupName,
        groupId: groupId,
        lastMessage: '',
        groupPic: groupProUrl,
        memberUid: [auth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
      );

      await firestore.collection('groups').doc(groupId).set(groupModel.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
