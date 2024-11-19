import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:second_brain/features/project_manager/models/folder.dart';

class ProjectManagerController extends GetxController {
  var folders = <Folder>[].obs;
  var crossAxisCount = 2.obs;

  // Method to add a project folder
  void addFolder(Folder folder) {
    folders.add(folder);
  }

  // Method to delete a project folder
  void deleteFolder(String folderId) {
    folders.removeWhere((folder) => folder.id == folderId);
  }

  // Method to edit a project folder
  void editFolder(String folderId, String newTitle) {
    int index = folders.indexWhere((folder) => folder.id == folderId);
    if (index != -1) {
      folders[index].title = newTitle;
      folders.refresh();
    }
  }

  // Method to load project folders
  void loadFolders(List<Folder> folderList) {
    folders.assignAll(folderList);
  }

  // Method to update crossAxisCount based on screen width
  void updateCrossAxisCount(double screenWidth) {
    if (screenWidth > 1400) {
      crossAxisCount.value = 4;
    } else if (screenWidth > 1100) {
      crossAxisCount.value = 3;
    } else {
      crossAxisCount.value = 2;
    }
  }
}
