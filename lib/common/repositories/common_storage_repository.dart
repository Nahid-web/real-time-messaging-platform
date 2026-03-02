import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:real_time_messaging_platform/common/config/app_config.dart';

final commonCloudinryStorageRepository = Provider(
  (ref) => CommonCloudinryStorageRepository(
    cloudinary: CloudinaryObject.fromCloudName(cloudName: cloudName),
  ),
);

class CommonCloudinryStorageRepository {
  final Cloudinary cloudinary;
  CommonCloudinryStorageRepository({
    required this.cloudinary,
  });

  Future<String> storeFileToCloundinry(
      String ref, String fileName, File file) async {
    String downloadUrl = '';
    final url = Uri.parse(uploadUrl);
    final request = http.MultipartRequest('POST', url);

    request.fields['upload_preset'] = uploadPreset;
    request.fields['folder'] = ref; // Specify the folder here

    request.fields['public_id'] = fileName; // Set the custom file name

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      final response = await request.send();

      final responseData = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseData);
      downloadUrl = jsonData['secure_url'];
      downloadUrl = downloadUrl;
      debugPrint(downloadUrl);
    } catch (e) {
      debugPrint("Exception during upload: $e");
    }

    return downloadUrl;
  }
}
