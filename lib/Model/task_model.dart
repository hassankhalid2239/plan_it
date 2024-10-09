class TaskModel {
  int? id;
  String? title;
  String? isCompleted;
  String? until;
  String? reminderDays;
  String? createdDate;
  String? dueTime;
  String? dueDate;

  TaskModel(
      {this.id, this.title, this.isCompleted, this.until, this.reminderDays, this.createdDate, this.dueTime, this.dueDate,});

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isCompleted = json['isCompleted'];
    dueDate = json['dueDate'];
    dueTime = json['dueTime'];
    reminderDays = json['reminderDays'];
    createdDate = json['createdDate'];
    until = json['until'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['isCompleted'] = isCompleted;
    data['dueDate'] = dueDate;
    data['dueTime'] = dueTime;
    data['createdDate'] = createdDate;
    data['reminderDays'] = reminderDays;
    data['until'] = until;
    return data;
  }
}
