import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/exam_provider.dart';
import '../models/exam.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Schedule'),
      ),
      body: Consumer<ExamProvider>(
        builder: (context, examProvider, child) {
          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                eventLoader: (day) {
                  return examProvider.getExamsForDay(day);
                },
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: _selectedDay == null
                    ? const Center(child: Text('Select a day to view exams'))
                    : _buildExamList(examProvider.getExamsForDay(_selectedDay!)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildExamList(List<Exam> exams) {
    if (exams.isEmpty) {
      return const Center(child: Text('No exams scheduled for this day'));
    }

    return ListView.builder(
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: ListTile(
            title: Text(exam.subject),
            subtitle: Text(
              '${DateFormat('HH:mm').format(exam.dateTime)}\n${exam.location.address}',
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}