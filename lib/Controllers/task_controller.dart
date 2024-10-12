import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plan_it/db/db_helper.dart';
import 'package:workmanager/workmanager.dart';

import '../Model/task_model.dart';
import '../Services/notification_services.dart';

class TaskController extends GetxController{
  var taskList = <TaskModel>[].obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxInt hour = 1.obs;
  RxInt minute = 0.obs;
  RxString currentDate=''.obs;
  RxString dueDate=''.obs;
  RxString uiDueDate=''.obs;
  RxString dueTime=''.obs;
  RxString period = 'am'.obs;
  RxInt currentIndex = 0.obs;
  RxList selectedDays = [].obs;
  int setHour=0;
  int setMint=0;



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
  String convertTo24HourFormat(String t) {
    // Input format: "h:mm am/pm"
    String time = t; // Yahan aap apna desired time input de sakte hain

    // Split kar ke hour, minute aur period (am/pm) extract karte hain
    List<String> parts = time.split(' ');
    List<String> timeParts = parts[0].split(':');

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    String period = parts[1].toLowerCase(); // AM ya PM

    // 12-hour se 24-hour format mein convert karna
    int hourIn24HourFormat = (period == 'pm' && hour != 12) ? hour + 12 : hour;
    if (period == 'am' && hour == 12) {
      hourIn24HourFormat = 0;
    }

    // Format output as "HH:mm"
    String convertedTime =
        '${hourIn24HourFormat.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    // print(convertedTime); // Output: "13:00" for example input "1:0 pm"
    return convertedTime;
  }
  spreadHourMinute(String horMin) {
    List<String> parts = horMin.split(':');
    setHour = int.parse(parts[0]);
    setMint = int.parse(parts[1]);
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
  void setTime(String tim) {
    String hour24 = convertTo24HourFormat(tim);
    spreadHourMinute(hour24);
    print('hour:$hour');
    print('Minute:$minute');
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
    setTime('${hour.value}:${minute.value} ${period.value}');
    // setTime(userTime.text.trim());
    int? id = await  DbHelper.fetchTaskIdByDueDate(task.dueDate!);
    if(dueDate.value.isNotEmpty){
      await NotificationService.showScheduleAlert(
          id: id!,
          title: "Task Alert",
          body: title,
          scheduled: true,
          date: DateTime.parse(dueDate.value),
          hour: setHour,
          min: setMint);
    }else{
      print(selectedDays);
    }

    // DbHelper.insert(task);
  }

  //get all data from Database
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DbHelper.query();
    taskList.assignAll(tasks.map((data) => TaskModel.fromJson(data)).toList());
    // getCompletedTask();
  }

  void markTaskCompleted(String isCompleted, TaskModel task) async {
    if(isCompleted=='true'){
      NotificationService.cancelAlert(task.id!);
    }else{
      spreadHourMinute(convertTo24HourFormat(task.dueTime!));
      int? id = await  DbHelper.fetchTaskIdByDueDate(task.dueDate!);
      await NotificationService.showScheduleAlert(
          id: id!,
          title: "Task Alert",
          body: task.title!,
          scheduled: true,
          date: DateTime.now(),
          hour: setHour,
          min: setMint);
    }
    await DbHelper.update(task.id!, isCompleted);
    getTasks();
  }

  void deleteTask(TaskModel task) {
    DbHelper.delete(task);
    NotificationService.cancelAlert(task.id!);
    getTasks();
  }

  void updateTask(TaskModel task) async {
    NotificationService.cancelAlert(task.id!);
    await DbHelper.updateTask(task);
    setTime('${hour.value}:${minute.value} ${period.value}');
    await NotificationService.showScheduleAlert(
        id: task.id!,
        title: "Task Alert",
        body: task.title!,
        scheduled: true,
        date: DateTime.parse(dueDate.value),
        hour: setHour,
        min: setMint);
    getTasks(); // Refresh task list
  }

  void getCurrentTask(TaskModel task)async{
    List<String> days = task.reminderDays!.split(',');
    splitTimeString(task.dueTime!);
    dueDate.value= task.dueDate!;
    uiDueDate.value= task.uiDueDate!;
    selectedDays.value = days;
  }

  void setAutoAlert()async{
    var taskList = <TaskModel>[];
    List<Map<String, dynamic>> tasks = await DbHelper.daysTask();
    taskList.addAll(tasks.map((data) => TaskModel.fromJson(data)).toList());
    for(int i=0; i<taskList.length; i++){
      List<String> days = taskList[i].reminderDays!.split(',');
      List<int> dinNum= convertDaysToNum(days);
      if(dinNum.contains(DateTime.now().weekday)){
        spreadHourMinute(convertTo24HourFormat(taskList[i].dueTime!));
        int? id = await  DbHelper.fetchTaskIdByDueDate(taskList[i].dueDate!);
        await NotificationService.showScheduleAlert(
            id: id!,
            title: "Task Alert",
            body: taskList[i].title!,
            scheduled: true,
            date: DateTime.now(),
            hour: setHour,
            min: setMint);
      }


    }
  }

  List<int> convertDaysToNum(List<String> days){
    List<int> daysNumber = [];
    for(int i=0; i<days.length; i++){
      daysNumber.add(getDayNumber(days[i]));
    }
    return daysNumber;
  }

  int getDayNumber(String day) {
    switch (day) {
      case 'Mon':
        return 1;
      case 'Tue':
        return 2;
      case 'Wed':
        return 3;
      case 'Thu':
        return 4;
      case 'Fri':
        return 5;
      case 'Sat':
        return 6;
      case 'Sun':
        return 7;
      default:
        return 0; // Agar koi valid weekday nahi hai, toh 0 return karega
    }
  }


  startBackgroundTask(){
    Workmanager().registerPeriodicTask('Task1', 'SetAutoAlert',
        frequency: const Duration(minutes: 15));
    print('&&&&& Task Started on Background &&&&&');
    setAutoAlert();
  }

}