import 'package:societe_generale_gamification/helpers/general.dart';

enum QuestionType { mcq, text }

class Test {
  List<Question> questions;
  String testName;
  String id;
  Test({required this.testName, this.questions = const [], this.id = 'test'});

  Map<String, dynamic> toJson() {
    return {
      'testName': testName,
      'questions': questions.map((e) => e.toJson()).toList()
    };
  }
}

class Question {
  String question;
  QuestionType questionType;
  List<Option> options;
  List<String> images;
  Option? answer;

  Question(
      {required this.question,
      required this.questionType,
      this.options = const [],
      this.images = const [],
      this.answer});

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'questionType': questionType.toString(),
      'options': options.map((e) => e.toJson()).toList(),
      'images': images,
      'answer': answer?.id,
    };
  }
}

class Option {
  String text;
  String? image;
  String id;

  Option({required this.text, required this.id, this.image});

  factory Option.create({required String text, String? image}) {
    return Option(
      text: text,
      image: image,
      id: getRandomString(3),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'image': image,
      'id': id,
    };
  }
}
