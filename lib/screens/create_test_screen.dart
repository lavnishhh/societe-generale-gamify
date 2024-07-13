import 'package:flutter/material.dart';
import 'package:societe_generale_gamification/helpers/question_helper.dart';

class CreateTestScreen extends StatefulWidget {
  final String testId;
  const CreateTestScreen({super.key, required this.testId});

  @override
  State<CreateTestScreen> createState() => _CreateTestScreenState();
}

class _CreateTestScreenState extends State<CreateTestScreen> {
  
  Test test = Test(questions: []);

  TextEditingController testNameController = TextEditingController();
  
  @override
  void initState() {
    testNameController.text = "Test ${widget.testId}";
    test.questions.add(
      Question(question: 'Type your question here', questionType: QuestionType.mcq, options: [
        Option(optionText: "Type your option here. Click '+' to add more.")
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
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: test.questions.length,
                    itemBuilder: (context, questionIndex) {
                      TextEditingController controller = TextEditingController();
                      Question question = test.questions[questionIndex];
                      controller.text = question.question;
                      return Container(
                        margin: const EdgeInsets.fromLTRB(0, 8, 0, 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, )
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
                                  optionController.text = option.optionText;
                                  return Container(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: optionController,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AppButton(content: Icon(Icons.add), onTap: (){
                                  setState(() {
                                    test.questions[questionIndex].options.add(Option(optionText: "Option ${question.options.length + 1}"));
                                  });
                                }),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: AppButton(
                    content: const Icon(Icons.add),
                    onTap: (){
                      setState(() {
                        test.questions.add(Question(question: "Question ${test.questions.length + 1}", questionType: QuestionType.mcq, options: [
                          Option(optionText: "Option 1")
                        ]));
                      });
                })
              )
            ],
          ),
        ),
      ),
    );
  }
}


class AppButton extends StatefulWidget {
  final Widget content;
  final VoidCallback onTap;
  const AppButton({super.key, required this.content, required this.onTap});

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: widget.content,
      ),
    );
  }
}

