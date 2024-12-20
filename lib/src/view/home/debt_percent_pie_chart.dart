import 'package:evochurch/src/constants/constant_index.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'pie_chart_indicator.dart';

class DebtPercentPieChart extends StatefulWidget {
  const DebtPercentPieChart({super.key});

  @override
  State<StatefulWidget> createState() => DebtPercentPieChartState();
}

class DebtPercentPieChartState extends State {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 0.8,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 0,
                sections: showingSections(),
              ),
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: EvoColor.blueDarkChartColor,
                  text: 'Al Dia',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: EvoColor.redDarkChartColor,
                  text: 'Atrasados',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: EvoColor.greenDarkChartColor,
                  text: 'Saldados',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: EvoColor.greyExtraDark,
                  text: 'Vencidos',
                  isSquare: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 170.0 : 150.0;
      final widgetSize = isTouched ? 75.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: EvoColor.blueDarkChartColor,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: EvoColor.white,
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              // 'assets/icons/ophthalmology-svgrepo-com.svg',
              svgAsset: Icon(
                Icons.thumb_up_alt_outlined,
                size: isTouched ? 40 : 30,
              ),
              size: widgetSize,
              borderColor: EvoColor.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: EvoColor.redDarkChartColor,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: EvoColor.white,
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              // 'assets/icons/librarian-svgrepo-com.svg',
              svgAsset: Icon(Icons.thumb_down_alt_outlined, size: isTouched ? 40 : 30,
              ),
              size: widgetSize,
              borderColor: EvoColor.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: EvoColor.greenDarkChartColor,
            value: 16,
            title: '16%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: EvoColor.white,
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              // 'assets/icons/fitness-svgrepo-com.svg',
              svgAsset: Icon(Icons.monetization_on_outlined, size: isTouched ? 40 : 30,
              ),
              size: widgetSize,
              borderColor: EvoColor.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: EvoColor.greyDark,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              // 'assets/icons/worker-svgrepo-com.svg',
              svgAsset: Icon(Icons.money_off_outlined, size: isTouched ? 40 : 30,
              ),
              size: widgetSize,
              borderColor: EvoColor.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Exception('Oh no');
      }
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.svgAsset,
    required this.size,
    required this.borderColor,
  });
  // final String svgAsset;
  final Icon svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(child: svgAsset
          //  SvgPicture.asset(
          //   svgAsset,
          // ),
          ),
    );
  }
}
