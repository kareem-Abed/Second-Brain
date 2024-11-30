import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:second_brain/features/project_manager/models/folder.dart';

class ProjectManagerController extends GetxController {
  var folders = <Folder>[].obs;
  final RxBool showBord = false.obs;
  var crossAxisCount = 2.obs;
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadFolders();
  }

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
    saveFolders();
  }

  // Method to load folders from GetStorage
  void loadFolders() {
    List<dynamic> storedFolders = storage.read<List<dynamic>>('folders') ?? [];
    folders.value = storedFolders.map((e) => Folder.fromJson(e)).toList();
  }

  // Method to save folders to GetStorage
  void saveFolders() {
    storage.write('folders', folders.map((e) => e.toJson()).toList());
  }
}
