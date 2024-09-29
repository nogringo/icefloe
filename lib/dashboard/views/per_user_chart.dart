import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icefloe/database/database.dart';

class PerUserChart extends StatefulWidget {
  final List<BarData> dataList;

  const PerUserChart(this.dataList, {super.key});

  final shadowColor = const Color(0xFFCCCCCC);

  @override
  State<PerUserChart> createState() => _PerUserChartState();
}

class _PerUserChartState extends State<PerUserChart> {
  BarChartGroupData generateBarGroup(
    int x,
    NostrUserData user,
    double value,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: Get.theme.colorScheme.onPrimaryContainer,
          width: 6,
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [1],
    );
  }

  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          borderData: FlBorderData(
            show: true,
            border: Border.symmetric(
              horizontal: BorderSide(
                color:
                    Get.theme.colorScheme.onPrimaryContainer.withOpacity(0.2),
              ),
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              drawBelowEverything: true,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    textAlign: TextAlign.left,
                  );
                },
              ),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Get.theme.colorScheme.onPrimaryContainer.withOpacity(0.2),
              strokeWidth: 1,
            ),
          ),
          barGroups: widget.dataList.asMap().entries.map((e) {
            final index = e.key;
            final data = e.value;
            return generateBarGroup(
              index,
              data.user,
              data.value,
            );
          }).toList(),
          barTouchData: BarTouchData(
            enabled: true,
            handleBuiltInTouches: false,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.transparent,
              tooltipMargin: 0,
              getTooltipItem: (
                BarChartGroupData group,
                int groupIndex,
                BarChartRodData rod,
                int rodIndex,
              ) {
                final user = widget.dataList[groupIndex].user;
                return BarTooltipItem(
                  user.alias ?? user.pubkey,
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    color: rod.color,
                    fontSize: 18,
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 12,
                      )
                    ],
                  ),
                );
              },
            ),
            touchCallback: (event, response) {
              if (event.isInterestedForInteractions &&
                  response != null &&
                  response.spot != null) {
                setState(() {
                  touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                });
              } else {
                setState(() {
                  touchedGroupIndex = -1;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}

class BarData {
  const BarData(this.user, this.value);
  final NostrUserData user;
  final double value;
}
