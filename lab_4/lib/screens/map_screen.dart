import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/exam_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  Set<Marker> _markers = {};

  void _updateMarkers(ExamProvider examProvider) {
    _markers = examProvider.exams.map((exam) {
      return Marker(
        markerId: MarkerId(exam.subject),
        position: LatLng(exam.location.latitude, exam.location.longitude),
        infoWindow: InfoWindow(
          title: exam.subject,
          snippet: '${exam.dateTime.toString().split('.')[0]}',
          onTap: () => _showExamDetails(exam),
        ),
      );
    }).toSet();
  }

  void _showExamDetails(exam) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              exam.subject,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            Text('Date: ${exam.dateTime.toString().split('.')[0]}'),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _openMapsWithDirections(
                LatLng(exam.location.latitude, exam.location.longitude),
              ),
              child: const Text('Get Directions'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMapsWithDirections(LatLng destination) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Locations'),
      ),
      body: Consumer<ExamProvider>(
        builder: (context, examProvider, child) {
          _updateMarkers(examProvider);

          return GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(42.0042, 21.4409), // Skopje coordinates
              zoom: 12,
            ),
            onMapCreated: (controller) {
              _controller = controller;
            },
            markers: _markers,
          );
        },
      ),
    );
  }
}