enum QuestionType {mcq, text}

class Test{
  List<Question> questions;

  Test({this.questions = const []});

}

class Question{
  String question;
  QuestionType questionType;
  List<Option> options;
  List<String> images;

  Question({required this.question, required this.questionType, this.options = const [], this.images = const []});

}

class Option{
  String optionText;
  String? optionImageUrl;

  Option({required this.optionText, this.optionImageUrl});

}