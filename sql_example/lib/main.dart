import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'addTodo.dart';
import 'todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<Database> database = initDatabase();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => DatabaseApp(database),
        '/add': (context) => AddTodoApp(database)
      },
    );
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "title TEXT, content TEXT, active INTEGER",
        );
      },
      version: 1
    );
  }
}

class DatabaseApp extends StatefulWidget {

  final Future<Database> db;
  const DatabaseApp(this.db, {super.key});

  @override
  State<StatefulWidget> createState() => _DatabaseApp();
}

class _DatabaseApp extends State<DatabaseApp> {
  Future<List<Todo>>? todoList;

  @override
  void initState() {
    super.initState();
    todoList = getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Example'),
        actions: <Widget>[
          TextButton(
              onPressed: () {},
              child: const Text('완료한 일', style: TextStyle(color: Colors.white),)
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return CircularProgressIndicator();
            case ConnectionState.done:
              if (snapshot.hasData) {
                return ListView.builder(
                    itemBuilder: (context, index) {
                      Todo todo = (snapshot.data as List<Todo>)[index];
                      return ListTile(
                        title: Text(todo.title!, style: const TextStyle(fontSize: 20)),
                        subtitle: Container(
                          child: Column(
                            children: <Widget>[
                              Text(todo.content!),
                              Text('체크 : ${todo.active == 1 ? 'true' : 'false'}'),
                              Container(
                                height: 1,
                                color: Colors.blue,
                              )
                            ],
                          )
                        ),
                        onTap: () async {
                          TextEditingController controller = TextEditingController(text: todo.content);

                          Todo result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('${todo.id} : ${todo.title}'),
                                  content: TextField(
                                    controller: controller,
                                    keyboardType: TextInputType.text,
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          todo.active == 1 ? todo.active = 0 : todo.active = 1;
                                          todo.content = controller.value.text;
                                          Navigator.of(context).pop(todo);
                                        },
                                    child: Text('예'),),
                                    TextButton(onPressed: () {
                                      Navigator.of(context).pop(todo);
                                    }, child: Text('아니요'))
                                  ],
                                );
                              }
                          );
                          _updateTodo(result);
                        },
                        onLongPress: () async {
                          Todo result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('${todo.id} : ${todo.title}'),
                                  content: Text('${todo.content}를 삭제하시겠습니까?'),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(todo);
                                        },
                                        child: Text('예')
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('아니오'))
                                  ],
                                );
                              });
                          _deleteTodo(result);
                        },
                      );
                    },
                    itemCount: (snapshot.data as List<Todo>).length,
                );
              } else {
                return Text('No Data');
              }
            }
            return CircularProgressIndicator();
          },
        future: todoList,
        ),),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final todo = await Navigator.of(context).pushNamed('/add');
          if (todo != null) {
            _insertTodo(todo as Todo);
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _insertTodo(Todo todo) async {
    final Database database = await widget.db;
    await database.insert('todos', todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    setState(() {
      todoList = getTodos();
    });
  }

  void _updateTodo(Todo todo) async {
    final Database database = await widget.db;
    await database.update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
    setState(() {
      todoList = getTodos();
    });
  }

  Future<List<Todo>> getTodos() async {
    final Database database = await widget.db;
    final List<Map<String, dynamic>> maps = await database.query('todos');

    return List.generate(maps.length, (i) {
      int active = maps[i]['active'] == 1 ? 1 : 0;
      return Todo(
        title: maps[i]['title'].toString(),
        content: maps[i]['content'].toString(),
        active: active,
        id: maps[i]['id']
      );
    });
  }

  void _deleteTodo(Todo todo) async {
    final Database database = await widget.db;
    await database.delete('todos', where: 'id=?', whereArgs: [todo.id]);
    setState(() {
      todoList = getTodos();
    });
  }

}
