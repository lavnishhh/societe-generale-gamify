import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:societe_generale_gamification/helpers/general.dart';
import 'package:societe_generale_gamification/helpers/main_helper.dart';
import 'package:societe_generale_gamification/screens/create_test_screen.dart';
import 'package:societe_generale_gamification/screens/module_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 1280 ? 1280 : MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hi Admin", style: TextStyle(fontSize: 60),),
              SizedBox(height: 20,),
              Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  children: [
                    Column(
                      children: [
                        AppButton(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Create Module", style: TextStyle(color: Colors.white),),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(Icons.add, color: Colors.white,),
                                ),
                              ],
                            ),
                            color: Theme.of(context).primaryColor,
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ModuleScreen(id: getRandomString(10))),
                              );
                            }
                        ),
                        FutureBuilder<List<Map<String, dynamic>>>(
                            future: MainHelper().fetchModules(),
                            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                              if(snapshot.connectionState != ConnectionState.done){
                                return CircularProgressIndicator();
                              }
                              if(snapshot.data == null){
                                return CircularProgressIndicator();
                              }
                              return Expanded(
                                child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> module = snapshot.data![index];
                                      return AppCard(
                                        title: module['name'],
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ModuleScreen(id: module['id'])),
                                          );
                                        },
                                      );
                                    }),
                              );
                            }
                        )
                      ],
                    ),
                    Column(
                      children: [
                        AppButton(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Create Test", style: TextStyle(color: Colors.white),),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(Icons.add, color: Colors.white,),
                                ),
                              ],
                            ),
                            color: Theme.of(context).primaryColor,
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CreateTestScreen(testId: getRandomString(10))),
                              );
                            }
                        ),
                        FutureBuilder<List<Map<String, dynamic>>>(
                            future: MainHelper().fetchTests(),
                            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                              if(snapshot.connectionState != ConnectionState.done){
                                return CircularProgressIndicator();
                              }
                              if(snapshot.data == null){
                                return CircularProgressIndicator();
                              }
                              return Expanded(
                                child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> module = snapshot.data![index];
                                      return AppCard(
                                        title: module['testName'],
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => CreateTestScreen(testId: module['id'])),
                                          );
                                        },
                                      );
                                    }),
                              );
                            }
                        )
                      ],
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppCard extends StatefulWidget {

  final String title;
  final Function onTap;

  const AppCard({super.key, required this.title, required this.onTap});
  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.onTap();
      },
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          children: [
            Text(widget.title)
          ],
        ),
      ),
    );
  }
}

