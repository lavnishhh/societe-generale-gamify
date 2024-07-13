import 'package:flutter/material.dart';
import 'package:societe_generale_gamification/classes/question_helper.dart';
import 'package:societe_generale_gamification/helpers/test_class.dart';

import '../helpers/general.dart';

class CreateTestScreen extends StatefulWidget {
  final String testId;
  const CreateTestScreen({super.key, required this.testId});

  @override
  State<CreateTestScreen> createState() => _CreateTestScreenState();
}

class _CreateTestScreenState extends State<CreateTestScreen> {

  Test test = Test(testName: "Untitled", questions: []);

  TextEditingController testNameController = TextEditingController();
  ScrollController questionViewController = ScrollController();

  @override
  void initState() {
    testNameController.text = "Test ${widget.testId}";
    test.testName = testNameController.text;
    test.id = widget.testId;
    test.questions.add(
      Question(question: 'Type your question here', questionType: QuestionType.mcq, options: [
        Option.create(text: "Type your option here. Click '+' to add more.")
      ])
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 1280 ? 1280 : MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Column(
                children: [
                  TextField(
                    controller: testNameController,
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: test.questions.length,
                      itemBuilder: (context, questionIndex) {
                        TextEditingController controller = TextEditingController();
                        Question question = test.questions[questionIndex];
                        controller.text = question.question;
                        return Container(
                          margin: const EdgeInsets.fromLTRB(0, 8, 0, 8.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).primaryColor, )
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: controller,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: test.questions[questionIndex].options.length,
                                  itemBuilder: (context, answerIndex) {
                                    TextEditingController optionController = TextEditingController();
                                    Option option = test.questions[questionIndex].options[answerIndex];
                                    optionController.text = option.text;
                                    print(String.fromCharCode(answerIndex + 65));
                                    return Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 4, 8, 0),
                                            child: Text("${String.fromCharCode(answerIndex + 65)}.", style: TextStyle(fontSize: 30),),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              child: TextField(
                                                controller: optionController,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    AppButton(content: Icon(Icons.add), onTap: (){
                                      setState(() {
                                        test.questions[questionIndex].options.add(Option.create(text: "Option ${question.options.length + 1}"));
                                      });
                                    }),
                                    Expanded(
                                        child: Container(
                                            height: 50,
                                            padding: EdgeInsets.only(left: 16),
                                            child: CustomCheckBox(
                                              options: test.questions[questionIndex].options,
                                              selectCallback: (answerIndex){
                                                test.questions[questionIndex].answer = test.questions[questionIndex].options[answerIndex];
                                              },
                                            )
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            AppButton(
                                content: const Icon(Icons.add),
                                onTap: (){
                                  setState(() {
                                    Option option = Option.create(text: "Option 1");
                                    test.questions.add(Question(question: "Question ${test.questions.length + 1}", questionType: QuestionType.mcq, answer: option, options: [
                                      option
                                    ]));
                                  });
                                }),
                            SizedBox(width: 16,),
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
                                  TestHelper().saveTest(test);
                                }),
                          ],
                        ),
                      )
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCheckBox extends StatefulWidget {
  final List<Option> options;
  final Function selectCallback;
  const CustomCheckBox({super.key, required this.options, required this.selectCallback});

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {

  List<Option> options = [];
  List<bool> selectedStates = [];
  int selectedAnswer = 0;
  @override
  void initState() {
    options = [widget.options.first];
    selectedStates = List.generate(widget.options.length, (index) => false);
    selectedStates[0] = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    while(widget.options.length > selectedStates.length){
      selectedStates.add(false);
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.options.length,
      itemBuilder: (context, answerIndex) {
        TextEditingController optionController = TextEditingController();
        Option option = widget.options[answerIndex];
        optionController.text = String.fromCharCode(answerIndex + 65);
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: InkWell(
            onTap: (){
              setState(() {
                selectedAnswer = answerIndex;
                selectedStates[answerIndex] = !selectedStates[answerIndex];
              });
              widget.selectCallback(answerIndex);
            },
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: answerIndex == selectedAnswer ? Theme.of(context).primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Theme.of(context).primaryColor),
              ),
              child: Center(child: Text(String.fromCharCode(answerIndex + 65), style: TextStyle(color: answerIndex == selectedAnswer ? Colors.white : Colors.black,),)),
            ),
          ),
        );
      },
    );
  }
}




