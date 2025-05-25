import 'package:flutter/material.dart';
import 'models/student.dart';
import 'models/behavior.dart';
import 'screens/student_list_screen.dart';

void main() {
  runApp(const BehaviorFirstApp());
}

class BehaviorFirstApp extends StatelessWidget {
  const BehaviorFirstApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BehaviorFirst Visualizer',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: StudentListScreen(students: mockStudents),
    );
  }
}

final List<Student> mockStudents = List.generate(15, (index) {
  final names = [
    'John Doe', 'Jane Smith', 'Emily Johnson', 'Michael Brown', 'Olivia Davis',
    'Ethan Wilson', 'Ava Moore', 'James Taylor', 'Sophia Anderson',
    'Benjamin Thomas', 'Isabella Jackson', 'Liam White', 'Mia Harris',
    'Noah Martin', 'Charlotte Thompson'
  ];

  final behaviorTypes = [
    'On-task', 'Off-task', 'Disruptive', 'Participating', 'Unresponsive'
  ];

  final random = index + 1;
  final List<Behavior> behaviors = List.generate(6, (i) {
    final type = behaviorTypes[(i + random) % behaviorTypes.length];
    final duration = 10 + ((i * random) % 40); // varied durations
    final date = '2025-05-${20 + (i % 5)}'; // 5 dates

    return Behavior(date: date, type: type, duration: duration);
  });

  return Student(
    id: 's$index',
    name: names[index],
    behaviors: behaviors,
  );
});