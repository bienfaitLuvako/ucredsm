import 'package:excel_reader/controller.dart';
import 'package:excel_reader/models.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExcelReader());
}

class ExcelReader extends StatelessWidget {
  const ExcelReader({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Excel File Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Controller controller = Controller();
  List<User> users = [];

  @override
  void initState() {
    controller.getFilePath().then((filePath) {
      if(filePath!=null){
        setState(() {
          users = controller.getUsersFromExcel(filePath);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Utilisateurs",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: users.isEmpty
          ? const Center(
              child: Text("Les données seront affichées ici"),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: const EdgeInsets.all(10),
                  color: const Color.fromARGB(255, 226, 232, 238),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Username : ${users[index].username}"),
                      Text("Password : ${users[index].password}")
                    ],
                  ),
                );
              }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ElevatedButton(
          onPressed: () {
            controller.pickFile().then((filePath) => setState(() {
                  if (filePath != null) {
                    users = controller.getUsersFromExcel(filePath);
                  }
                }));
          },
          child: const Text(
            "Sélectionner le fichier excel",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
