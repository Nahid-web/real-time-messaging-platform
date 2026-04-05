import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_time_messaging_platform/common/widgets/error.dart';
import 'package:real_time_messaging_platform/common/widgets/loader.dart';
import 'package:real_time_messaging_platform/features/select_contacts/controller/select_contact_controller.dart';

class SelectedGroupContactsNotifier extends Notifier<List<Contact>> {
  @override
  List<Contact> build() => [];

  void add(Contact contact) => state = [...state, contact];
  void remove(Contact contact) => state = state.where((c) => c.id != contact.id).toList();
  void clear() => state = [];
}

final selectedGroupContacts = NotifierProvider<SelectedGroupContactsNotifier, List<Contact>>(
  SelectedGroupContactsNotifier.new,
);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List selectedContactsIndex = [];

  void selectedContact(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref.read(selectedGroupContacts.notifier).add(contact);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
          data: (contactList) => Expanded(
            child: ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return InkWell(
                  onTap: () => selectedContact(index, contact),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        contact.displayName ?? 'Unknown',
                      ),
                      leading: selectedContactsIndex.contains(index)
                          ? IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.done),
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          error: (error, stackTrace) => ErrorScreen(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
