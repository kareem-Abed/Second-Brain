import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:second_brain/features/project_manager/models/folder.dart';

class ProjectManagerController extends GetxController {
  var folders = <Folder>[].obs;
  var crossAxisCount = 2.obs;
  void updateCrossAxisCount(double screenWidth) {
    if (screenWidth > 1400) {
      crossAxisCount.value = 4;
    } else if (screenWidth > 1100) {
      crossAxisCount.value = 3;
    } else {
      crossAxisCount.value = 2;
    }
  }

  // Method to add a project folder
  void addFolder(Folder folder) {
    folders.add(folder);
  }
}
