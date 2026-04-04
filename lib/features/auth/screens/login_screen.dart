import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_time_messaging_platform/common/utils/colors.dart';
import 'package:real_time_messaging_platform/common/utils/utils.dart';
import 'package:real_time_messaging_platform/common/widgets/custom_button.dart';
import 'package:real_time_messaging_platform/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    } else {
      showSnackBar(context: context, content: 'Fill out all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "We'll send a one-time code to verify your number",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: greyColor, fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  // Country + phone input card
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: mobileChatBoxColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: pickCountry,
                          icon: const Icon(Icons.flag_outlined,
                              color: tabColor, size: 18),
                          label: Text(
                            country == null
                                ? 'Select Country'
                                : '${country!.name} (+${country!.phoneCode})',
                            style: const TextStyle(color: tabColor),
                          ),
                        ),
                        const Divider(color: dividerColor, height: 1),
                        Row(
                          children: [
                            if (country != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  '+${country!.phoneCode}',
                                  style:
                                      const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            Expanded(
                              child: TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  hintText: 'Phone number',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomButton(text: 'NEXT', onPressed: sendPhoneNumber),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
