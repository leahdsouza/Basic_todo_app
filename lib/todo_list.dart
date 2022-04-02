import 'package:flutter/material.dart';
import 'package:todo_app/loading.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/services/database_services.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool isComplete = false;
  TextEditingController todoTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Todo>>(
          stream: DatabaseService().listTodos(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return Loading();
            }
            List<Todo>? todos = snapshot.data;
            return Padding(

              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Todos",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 10),
                  Divider(color: Colors.grey[600]),
                  SizedBox(height: 20),
                  ListView.separated(
                    separatorBuilder: (context,index) => Divider(color: Colors.grey[800],),
                    shrinkWrap: true,
                    itemCount:todos!.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                          key: Key(todos[index].title),
                          background: Container(
                            padding: EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.delete),
                            color: Colors.red,
                          ),
                          onDismissed: (direction) async {
                            await DatabaseService().removeTodo(todos[index].uid);
                            _deleteTodo(context);
                          },
                          child: ListTile(
                            onTap: () {
                              DatabaseService().completeTask(todos[index].uid);
                            },
                            leading: Container(
                              padding: EdgeInsets.all(2.0),
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: todos[index].isComplete? Icon(
                                Icons.check,
                                color: Colors.white,
                              ) : Container(),
                            ),
                            title: Text(todos[index].title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[200],
                              ),
                            ),
                          )
                      );
                    },
                  ),
                ],
              ),
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              backgroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Text(
                    'Add Todo',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.grey,
                        size: 30,
                      )
                  )
                ],
              ),
              children: [
                Divider(),
                TextFormField(
                  controller: todoTitleController,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: Colors.white,
                  ),
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "eg. shop",
                    hintStyle: TextStyle(
                      color: Colors.white60,
                    ),
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TextButton(
                    child: Text("Add"),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.pink,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    ),
                    onPressed: () async {
                      if(todoTitleController.text.isNotEmpty) {
                        await DatabaseService().createNewTodo(todoTitleController.text.trim());
                        Navigator.pop(context);
                        _showDialog(context);
                      };
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),

    );

  }
}


void _deleteTodo(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Alert!!"),
        content: new Text("Todo Deleted!"),
        actions: <Widget>[
          new TextButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );

}



void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Alert!!"),
        content: new Text("Todo added!"),
        actions: <Widget>[
          new TextButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
          ),
        ],
      );
    },
  );

}
