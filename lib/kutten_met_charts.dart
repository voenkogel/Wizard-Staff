import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kutten_met_flutter/Session.dart';

import 'KlokDataPoint.dart';
import 'main.dart';

class BeerChart extends StatefulWidget {
  const BeerChart({Key? key}) : super(key: key);

  @override
  BeerChartState createState() => BeerChartState();
}

class BeerChartState extends State<BeerChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.20,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 18.0, left: 12.0, top: 50, bottom: 12),
                child: LineChart(
                  beerData(),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: SizedBox(
                width: 150,
                height: 40,
                child: Text(
                  'Beers over time',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Hive.box('settings').get('darkMode')
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData beerData() {
    return LineChartData(
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xFFd3d3d3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: const Color(0xFFd3d3d3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: getSpots().length <= 6 ? 4 : null,
            getTextStyles: (context, value) => TextStyle(
                color: Hive.box('settings').get('darkMode')
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 12),
            getTitles: (value) {
              return getLabel(value);
            },
            margin: 8,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            interval: getSpots().length <= 12 ? 1 : null,
            getTextStyles: (context, value) => TextStyle(
              color: Hive.box('settings').get('darkMode')
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 13,
            ),
            getTitles: (value) {
              if (value % 1 != 0) return "";
              return value.toInt().toString();
            },
            reservedSize: 32,
            margin: 12,
          ),
        ),
        borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xFFd3d3d3), width: 1)),
        minX: 0,
        maxX: getSpots().length <= 1 ? 1 : getSpots().last.x.toDouble(),
        minY: 0,
        maxY: getSpots().length <= 1 ? 1 : getSpots().last.y.toDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: getSpots(),
            isCurved: true,
            curveSmoothness: 0.01,
            colors: gradientColors,
            barWidth: 4,
            isStrokeCapRound: false,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                if (flSpot.x == 0 || flSpot.x == 6) {
                  return null;
                }

                return LineTooltipItem(
                  'Beer ${flSpot.y.toInt()} \n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: getLabel(flSpot.x).toString(),
                      style: TextStyle(
                        color: Colors.grey[100],
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ));
  }

  List<FlSpot> getSpots() {
    if (!hiveInitialized) return [];
    var session = getSession();
    if (session.klokData.isEmpty) return [];

    var data = session.klokData;
    List<FlSpot> output = [];
    output.add(const FlSpot(0, 0));
    for (int i = 0; i < data.length; i++) {
      var diff = data[i].dateTime.difference(session.startTime);
      output.add(FlSpot(diff.inSeconds.toDouble(), data[i].id.toDouble()));
    }
    return output;
  }

  String getLabel(double value) {
    if (!hiveInitialized) return "";
    var startTime = getSession().startTime;
    var pointTime = startTime.add(Duration(seconds: value.toInt()));

    //compensate for single digit times
    var hour = pointTime.hour.toString();
    var minute = pointTime.minute.toString();
    hour = hour.length <= 1 ? "0" + hour : hour;
    minute = minute.length <= 1 ? "0" + minute : minute;

    return hour + ":" + minute;
  }
}
