import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gym_track_app/datetime/data_time.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDateYYYYMMDD;

  const MyHeatMap({
    super.key,
    required this.datasets,
    required this.startDateYYYYMMDD,
  });

  @override
  Widget build(BuildContext context) {
     HeatMap(
    {required DateTime startDate,
    required DateTime endDate,
    Map<DateTime, int>? datasets,
    Color? defaultColor,
    required Color textColor,
    required bool showColorTip,
    required bool showText,
    required bool scrollable,
    required int size,
    required Map<int, MaterialColor> colorSets}) {}
    return Container(
      padding: EdgeInsets.all(25),
      child: HeatMap(
          startDate: createDateTimeObject(startDateYYYYMMDD),
          endDate: DateTime.now().add(const Duration(days: 0)),
          datasets: datasets,
          defaultColor: Colors.grey[200],
          textColor: Colors.white,
          showColorTip: false,
          showText: true,
          scrollable: true,
          size: 20,
          colorSets: const {
            1: Colors.green,
          }),
    );
  }
 }




