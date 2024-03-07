import 'package:saasify/data/models/task/get_all_tasks_model.dart';

abstract class TaskEvents {}

class AssignTask extends TaskEvents {
  final bool isEdit;

  AssignTask({required this.isEdit});
}

class UpdateTaskStatus extends TaskEvents {
  final TasksAssignedMe task;
  final String status;
  final String? comments;

  UpdateTaskStatus({this.comments, required this.task, required this.status});
}

class FetchAllTasks extends TaskEvents {}