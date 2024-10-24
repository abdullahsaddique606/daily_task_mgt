import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TaskSelectionController extends GetxController {
  var selectedTaskIds = <String>{}.obs;
  var selectAll = false.obs;

  void toggleSelectAll(bool value, List<DocumentSnapshot> tasks) {
    selectAll.value = value;
    if (value) {
      selectedTaskIds.clear();
      for (var task in tasks) {
        selectedTaskIds.add(task.id);
      }
    } else {
      selectedTaskIds.clear();
    }
  }

  void toggleSelect(String taskId) {
    if (selectedTaskIds.contains(taskId)) {
      selectedTaskIds.remove(taskId);
    } else {
      selectedTaskIds.add(taskId);
    }
  }

  bool isAnyTaskIncomplete(List<DocumentSnapshot> tasks) {
    return selectedTaskIds.any((taskId) {
      var task = tasks.firstWhere((task) => task.id == taskId).data() as Map<String, dynamic>;
      return task['isCompleted'] == false;
    });
  }

  bool isAnyTaskComplete(List<DocumentSnapshot> tasks) {
    return selectedTaskIds.any((taskId) {
      var task = tasks.firstWhere((task) => task.id == taskId).data() as Map<String, dynamic>;
      return task['isCompleted'] == true;
    });
  }
}
