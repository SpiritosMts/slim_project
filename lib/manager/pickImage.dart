


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_care/main.dart';

import 'styles.dart';

Future<PickedFile>  showImageChoiceDialog()async  {

  Future<PickedFile> selectImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(
      source: source,
    );
    Get.back();
    return pickedFile!;
  }

  PickedFile? image ;

  await  showDialog(
      context: navigatorKey.currentContext!,
      builder: (_) {
        return AlertDialog(
          backgroundColor: dialogsCol,
          title:  Text(
            "Choose source".tr,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Divider(
                  height: 1,
                ),
                ListTile(
                  onTap: () async{
                    image = await selectImage(ImageSource.gallery);
                  },
                  title: Text("Gallery".tr),
                  leading: const Icon(
                    Icons.image,
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                ListTile(
                  onTap: () async {
                    image = await selectImage(ImageSource.camera);
                  },
                  title: Text("Camera".tr),
                  leading: const Icon(
                    Icons.camera,
                  ),
                ),
              ],
            ),
          ),
        );
      });


  return image!;

}
