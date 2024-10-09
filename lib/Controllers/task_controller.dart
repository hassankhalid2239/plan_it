import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plan_it/db/db_helper.dart';

import '../Model/task_model.dart';

class TaskController extends GetxController{
  var taskList = <TaskModel>[].obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxInt hour = 1.obs;
  RxInt minute = 0.obs;
  RxString currentDate=''.obs;
  RxString dueDate=''.obs;
  RxString dueTime=''.obs;
  RxString period = 'am'.obs;
  RxInt currentIndex = 0.obs;
  RxList selectedDays = [].obs;



  void convertTo12HourFormat() {
    // Input format: "HH:mm"
    String date= "${DateTime.now().hour}:${DateTime.now().minute}";
    List<String> parts = date.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    // Convert to 12-hour format
    int hourIn12HourFormat = hour % 12 == 0 ? 12 : hour % 12;
    String period = hour >= 12 ? 'pm' : 'am';

    // Format output as "h:mmam/pm"
    currentDate.value = '$hourIn12HourFormat:${minute.toString().padLeft(2, '0')} $period';
  }
  void splitTimeString(String timeString) {
    List<String> timeParts = timeString.split(" ");
    List<String> hoursAndMinutes = timeParts[0].split(":");

    // String hours = hoursAndMinutes[0];
    // String minutes = hoursAndMinutes[1];
    // String period = timeParts[1];
    hour.value= int.parse(hoursAndMinutes[0]);
    minute.value= int.parse(hoursAndMinutes[1]);
    period.value=timeParts[1];
    if(period.value=='am'){
      currentIndex.value=0;
    }else{
      currentIndex.value=1;
    }
  }

  //insert data
  void addTask(String title)async{
    String daysString = selectedDays.join(',');
    String untilTime= '${hour.value}:${minute.value} ${period.value}';
    final task = TaskModel(
        title: title,
        isCompleted: "false",
        until: '',
        reminderDays: selectedDays.isEmpty?'':daysString,
        createdDate: DateFormat('E, d MMM yyyy').format(DateTime.now()),
        dueTime: untilTime,
        dueDate: dueDate.value);
    await DbHelper.insert(task);
    getTasks();
    // DbHelper.insert(task);
  }

  //get all data from Database
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DbHelper.query();
    taskList.assignAll(tasks.map((data) => TaskModel.fromJson(data)).toList());
    // getCompletedTask();
  }

  void markTaskCompleted(int id, String isCompleted) async {
    await DbHelper.update(id, isCompleted);
    getTasks();
  }

  void deleteTask(TaskModel task) {
    DbHelper.delete(task);
    getTasks();
  }

  void updateTask(TaskModel task) async {
    await DbHelper.updateTask(task);
    getTasks(); // Refresh task list
  }

  void getCurrentTask(TaskModel task)async{
    List<String> days = task.reminderDays!.split(',');
    splitTimeString(task.dueTime!);
    dueDate.value= task.dueDate!;
    selectedDays.value = days;
  }

}