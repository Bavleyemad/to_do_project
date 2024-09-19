class Task{
String? id;
String? title;
String? description;
int? data;
int? time;
bool? isDone;
Task({this.id,this.title,this.description,this.data,this.time,this.isDone=false});
Task.fromFireStore(Map<String,dynamic>?data):
    this(
      id: data?["id"],
      title: data?["title"],
      description: data?["description"],
      data: data?["data"],
      time: data?["time"],
      isDone: data?["IsDone"]
    );
Map<String,dynamic>toFireStore(){
    return{
        "id":id,
        "title":title,
        "descrption":description,
        "data":data,
        "time":time,
        "isDone":isDone

    };
}
}