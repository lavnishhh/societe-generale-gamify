import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societe_generale_gamification/helpers/general.dart';
import 'package:societe_generale_gamification/helpers/main_helper.dart';
import 'package:societe_generale_gamification/screens/create_test_screen.dart';

class ModuleScreen extends StatefulWidget {
  final String? id;

  const ModuleScreen({super.key, required this.id});

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {

  Map<String, dynamic> module = {
    'name': 'Untitled',
    'content': [],
    'participants': [],
  };

  Future<List<Map<String, dynamic>>>? fetchTests;
  List<Future> futures = [];

  @override
  void initState() {

    fetchTests = MainHelper().fetchTests();
    futures = [fetchTests!];

    if(widget.id != null){
      futures.add(MainHelper().fetchModule(widget.id!));
    }

    module['id'] = widget.id;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List>(
      future: Future.wait(futures),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          debugPrintStack();
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {

          List<Map<String, dynamic>>? tests = snapshot.data![0] as List<Map<String, dynamic>>;
          if(snapshot.data![1]!=null){
            print("fwe");
            module = snapshot.data![1] as Map<String, dynamic>;
          }

          return SubModuleScreen(tests: tests, module: module,);
        }
      },
    );
  }
}


class SubModuleScreen extends StatefulWidget {

  final List<Map<String, dynamic>> tests;
  final Map<String, dynamic> module;

  const SubModuleScreen({super.key, required this.tests, required this.module});

  @override
  State<SubModuleScreen> createState() => _SubModuleScreenState();
}

class _SubModuleScreenState extends State<SubModuleScreen> {

  TextEditingController moduleNameController = TextEditingController();

  @override
  void initState() {
    moduleNameController.text = widget.module['name'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width > 1280 ? 1280 : MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: moduleNameController,
                    ),
                    SizedBox(height: 32,),
                    Row(
                      children: [
                        AppButton(
                            content: Row(
                              children: [
                                Text("Save test"),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  child: const Icon(Icons.save),
                                )
                              ],
                            ),
                            onTap: (){
                              // print(test.toJson());
                              widget.module['name'] = moduleNameController.text;
                              MainHelper().saveModule(widget.module);
                            }),
                        SizedBox(width: 10,),
                        AppButton(
                            content: Row(
                              children: [
                                Text("Create Quiz", style: TextStyle(color: Colors.white),),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(Icons.add, color: Colors.white,),
                                )
                              ],
                            ),
                            color: Colors.black,
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CreateTestScreen(testId: 'Untitled')),
                              );
                            }),
                        SizedBox(width: 10,),
                        DropdownButton<String>(
                          value: widget.tests.first['name'],
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              Map<String, dynamic> selectedTest = widget.tests.firstWhere((element) => element['id'] == value);
                              if(widget.module['content'].contains(selectedTest['id'])){
                                return;
                              }
                              widget.module['content'].add(selectedTest['id']);
                            });
                          },
                          items: widget.tests.map<DropdownMenuItem<String>>((Map<String, dynamic> test) {
                            return DropdownMenuItem<String>(
                              value: test['id'],
                              child: Text(test['testName']),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: widget.module['content'].length,
                        itemBuilder: (context, testIndex) {
                          return Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Column(
                              children: [
                                Text(
                                    widget.module['content'][testIndex],
                                  style: TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }
}
