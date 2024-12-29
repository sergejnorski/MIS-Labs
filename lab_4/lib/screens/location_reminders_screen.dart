import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exam_provider.dart';
import '../services/location_service.dart';

class LocationRemindersScreen extends StatefulWidget {
  const LocationRemindersScreen({Key? key}) : super(key: key);

  @override
  State<LocationRemindersScreen> createState() => _LocationRemindersScreenState();
}

class _LocationRemindersScreenState extends State<LocationRemindersScreen> {
  final LocationService _locationService = LocationService();
  bool _isMonitoring = false;

  @override
  void initState() {
    super.initState();
    _locationService.initialize();
  }

  void _toggleMonitoring(ExamProvider examProvider) {
    setState(() {
      _isMonitoring = !_isMonitoring;
      if (_isMonitoring) {
        _locationService.startMonitoring(examProvider.exams);
      } else {
        _locationService.stopMonitoring();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Reminders'),
        actions: [
          Consumer<ExamProvider>(
            builder: (context, examProvider, child) {
              return Switch(
                value: _isMonitoring,
                onChanged: (_) => _toggleMonitoring(examProvider),
              );
            },
          ),
        ],
      ),
      body: Consumer<ExamProvider>(
        builder: (context, examProvider, child) {
          final exams = examProvider.exams;

          if (exams.isEmpty) {
            return const Center(
              child: Text('No exams scheduled'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final exam = exams[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(exam.subject),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reminder radius: ${exam.reminderRadius.round()}m',
                      ),
                      Text(
                        'Status: ${exam.hasTriggeredReminder ? 'Reminded' : 'Pending'}',
                        style: TextStyle(
                          color: exam.hasTriggeredReminder
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    exam.hasTriggeredReminder
                        ? Icons.check_circle
                        : Icons.notifications_active,
                    color: exam.hasTriggeredReminder
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}