import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TestChartScreen extends StatelessWidget {
  const TestChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Chart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(0, 1),
                    const FlSpot(1, 3),
                    const FlSpot(2, 2),
                    const FlSpot(3, 5),
                    const FlSpot(4, 4),
                    const FlSpot(5, 6),
                    const FlSpot(6, 5),
                  ],
                  isCurved: true,
                  color: Theme.of(context).primaryColor,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}