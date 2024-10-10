import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plan_it/view/update_task_screen.dart';
import '../Controllers/task_controller.dart';
import '../Services/notification_services.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskController.getTasks();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        // backgroundColor: Color(0xffd9daf3),
        centerTitle: true,
        title: InkWell(
          onTap: () async {
            await NotificationService.showNotification(
              title: "Title of the notification",
              body: "Body of the notification",
            );
          },
          child: Text(
            DateFormat.yMMMd().format(_taskController.selectedDate.value)==DateFormat.yMMMd().format(DateTime.now())?
            'Today': DateFormat.yMMMd().format(_taskController.selectedDate.value),
            style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: DatePicker(
            DateTime.now(),
            height: 100,
            width: 75,
            initialSelectedDate: DateTime.now(),
            selectionColor: Color(0xff6368D9),
            selectedTextColor: Colors.white,
            dateTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            ),
            dayTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            ),
            monthTextStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            ),
            onDateChange: (date){
              setState(() {
                _taskController.selectedDate.value=date;
              });

            },
          ),
        ),
      ),
      body: Obx((){
        return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child:  _taskController.taskList.isNotEmpty?
            ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 50),
              itemCount: _taskController.taskList.length,
              // itemCount: 10,
              itemBuilder: (context, index) {
                List<String> days = _taskController.taskList[index].reminderDays!.split(',');
                if(_taskController.taskList[index].dueDate==DateFormat('E, d MMM yyyy').format(_taskController.selectedDate.value)|| days.contains(DateFormat('E').format(_taskController.selectedDate.value))){
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child:  Dismissible(
                        // background: Container(color: Colors.red,),
                        key: Key(_taskController.taskList[index].id.toString()),
                        onDismissed: (direction) {
                          _taskController.deleteTask(_taskController.taskList[index]);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          // color: Theme.of(context).colorScheme.onSecondary,
                          color: _taskController.taskList[index].isCompleted=='true'
                              ? Color(0xff989cff)
                              : Color(0xff767eff),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            splashFactory: InkRipple.splashFactory,
                            splashColor: Color(0xff6368D9),
                            overlayColor:
                            const WidgetStatePropertyAll(Color(0xff6368D9)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateTaskScreen(
                                        currentTask: _taskController.taskList[index],
                                      )));
                            },
                            child: ListTile(
                                title: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  _taskController.taskList[index].title!,
                                  // 'Task $index',
                                  style: TextStyle(
                                      color: _taskController.taskList[index].isCompleted=='true'?Colors.white70:Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                subtitle:Text(
                                  _taskController.taskList[index].dueDate!.isNotEmpty?
                                  _taskController.taskList[index].dueDate!:
                                  _taskController.taskList[index].reminderDays!,
                                  // 'Due date: 1 Sep, 2021',
                                  style: TextStyle(
                                      color: _taskController.taskList[index].isCompleted=='true'?Colors.
                                      white70:Colors.white, fontSize: 12),
                                ),
                                trailing: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  _taskController.taskList[index].dueTime!,
                                  // 'Task $index',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: _taskController.taskList[index].isCompleted=='true'?Colors.white70:Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                // subtitle: Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Text(
                                //       maxLines: 1,
                                //       overflow: TextOverflow.ellipsis,
                                //       'Use Tensor flow and Computer Vision to build object reorganization apps build with flutter',
                                //       // 'This is description of task This is description of task This is description of task This is description of task This is description of task$index',
                                //       style: TextStyle(
                                //         color: Colors.white,
                                //       ),
                                //     ),
                                //     const SizedBox(
                                //       height: 10,
                                //     ),
                                //     Text(
                                //       'Due date: ${DateFormat('EEE, d MMMM').format(DateTime.now())}',
                                //       // 'Due date: 1 Sep, 2021',
                                //       style: TextStyle(
                                //           color: Colors.white, fontSize: 12),
                                //     ),
                                //   ],
                                // ),
                                leading: GestureDetector(
                                    onTap: () {
                                      if(_taskController.taskList[index].isCompleted=="true"){
                                        _taskController.markTaskCompleted(
                                            int.parse(_taskController.taskList[index].id.toString()),
                                            'false');
                                      }else{
                                        _taskController.markTaskCompleted(
                                            int.parse(_taskController.taskList[index].id.toString()),
                                            'true');
                                      }
                                    },
                                    child:  Obx((){
                                      return Icon(
                                        _taskController.taskList[index].isCompleted=='true'?
                                        Icons.check_circle:
                                        Icons.check_circle_outline,

                                        color: Colors.white,
                                        size: 30,
                                      );
                                    })
                                )
                              // trailing:index%2==0? Icon(Icons.check_circle_outline,color: Color(0xffB3B7EE),) : Icon(Icons.check_circle,color: Color(0xffB3B7EE),)
                            ),
                          ),
                        ),
                      )
                  );
                }else{
                  return SizedBox();
                }

              },
            ):
            Center(
              child: Text(
                "There's no task!",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            )
        );
      }),
      floatingActionButton: SizedBox.fromSize(
        size: const Size.square(60),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddTaskScreen()));
          },
          // shape: const CircleBorder(),
          // backgroundColor: Theme.of(context).colorScheme.onSecondary,
          backgroundColor: const Color(0xff6368D9),
          child: Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}





