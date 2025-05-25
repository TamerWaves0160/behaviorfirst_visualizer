import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/behavior.dart';

Color getColor(String type) {
  switch (type) {
    case 'On-task':
      return Colors.green;
    case 'Off-task':
      return Colors.red;
    case 'Disruptive':
      return Colors.orange;
    case 'Participating':
      return Colors.blue;
    case 'Unresponsive':
      return Colors.grey;
    default:
      return Colors.teal;
  }
}

class BehaviorChart extends StatefulWidget {
  final List<Behavior> behaviors;

  const BehaviorChart({super.key, required this.behaviors});

  @override
  State<BehaviorChart> createState() => _BehaviorChartState();
}

class _BehaviorChartState extends State<BehaviorChart> {
  String? selectedType;

  List<Behavior> get filteredBehaviors {
    if (selectedType == null) return widget.behaviors;
    return widget.behaviors.where((b) => b.type == selectedType).toList();
  }

  Widget buildLegend() {
    final legendItems = {
      'On-task': Colors.green,
      'Off-task': Colors.red,
      'Disruptive': Colors.orange,
      'Participating': Colors.blue,
      'Unresponsive': Colors.grey,
    };

    return Wrap(
      spacing: 12,
      children: legendItems.entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 12, height: 12, color: entry.value),
            const SizedBox(width: 4),
            Text(entry.key),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<String>(
          hint: const Text('Filter by behavior'),
          value: selectedType,
          items: <String>[
            'On-task',
            'Off-task',
            'Disruptive',
            'Participating',
            'Unresponsive',
          ].map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList()
            ..insert(0, const DropdownMenuItem(value: null, child: Text('All'))),
          onChanged: (value) {
            setState(() {
              selectedType = value;
            });
          },
        ),
        const SizedBox(height: 12),
        buildLegend(),
        const SizedBox(height: 12),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Builder(
                builder: (context) {
                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 60,
                      barTouchData: BarTouchData(
                        enabled: false, // disables tooltips to prevent crash
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              return index < filteredBehaviors.length
                                  ? Text(filteredBehaviors[index].date.substring(5))
                                  : const Text('');
                            },
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      barGroups: filteredBehaviors.asMap().entries.map((entry) {
                        final index = entry.key;
                        final behavior = entry.value;

                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: behavior.duration.toDouble(),
                              width: 20,
                              color: getColor(behavior.type),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
