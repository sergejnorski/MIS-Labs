import 'package:flutter/foundation.dart';
import '../models/exam.dart';

class ExamProvider with ChangeNotifier {
  List<Exam> _exams = [];

  List<Exam> get exams => _exams;

  void addExam(Exam exam) {
    _exams.add(exam);
    notifyListeners();
  }

  List<Exam> getExamsForDay(DateTime day) {
    return _exams.where((exam) =>
    exam.dateTime.year == day.year &&
        exam.dateTime.month == day.month &&
        exam.dateTime.day == day.day
    ).toList();
  }

  void removeExam(Exam exam) {
    _exams.remove(exam);
    notifyListeners();
  }
}