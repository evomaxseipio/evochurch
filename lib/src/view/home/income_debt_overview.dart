import 'package:evochurch/src/utils/responsive.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view/home/short_data.dart';
import 'package:evochurch/src/widgets/widget_index.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../constants/constant_index.dart';

class IncomeDebtOverview extends HookWidget {
  IncomeDebtOverview({super.key});

  final List<FlSpot> _earningChart = const [
    FlSpot(0, 4),
    FlSpot(0.5, 1.5),
    FlSpot(1, 3),
    FlSpot(1.5, -2),
    FlSpot(2, 5),
    FlSpot(2.5, -1),
    FlSpot(3, 3),
  ];
  final List<FlSpot> _customerChart = const [
    FlSpot(0, 4),
    FlSpot(0.5, 1.5),
    FlSpot(1, 3),
    FlSpot(1.5, 1),
    FlSpot(2, 4),
    FlSpot(2.5, 3.5),
    FlSpot(3, 0),
  ];
  LineChartData mainData(List<FlSpot> list) {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            double value = 0.0;
            for (LineBarSpot lineBarSpot in touchedSpots) {
              value = lineBarSpot.y;
            }
            return [
              LineTooltipItem(
                value.toString(),
                const TextStyle(
                  color: EvoColor.darkDrawertext,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ];
          },
          // getTooltipColor: ColorConst.grey800,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      gridData: const FlGridData(
        drawVerticalLine: false,
        drawHorizontalLine: false,
      ),
      titlesData: const FlTitlesData(
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      minX: 0,
      maxX: 4,
      minY: 0,
      maxY: 4,
      lineBarsData: [
        LineChartBarData(
          dotData: const FlDotData(show: true),
          spots: list,
          color: EvoColor.primary.withOpacity(0.8),
          barWidth: 2,
          isStrokeCapRound: true,
          isCurved: true,
          belowBarData: BarAreaData(
            show: true,
            color: EvoColor.primary.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  final List<int> _chartDataOne = [
    110,
    80,
    150,
    100,
    50,
    175,
    120,
    100,
    135,
    145,
    150,
    100
  ];
  final List<double> _chartDataTwo = [
    125,
    130,
    70,
    125,
    75,
    110,
    60,
    135,
    115,
    105,
    110,
    100
  ];
  final List<String> _bottom = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: EvoWhiteCard(
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 4,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: Responsive.isMobile(context) ? 978 : 455),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "EvoString.earningsAndExpenses",
                      style: EvoTheme.title(context).copyWith(fontSize: 18.0),
                    ),
                    const Spacer(),
                    const CircleAvatar(
                      radius: 4.0,
                      backgroundColor: EvoColor.primary,
                    ),
                    EvoBox.w4,
                    Text('Ingresos',
                        style: EvoTheme.text(context).copyWith(
                            fontWeight: FontWeight.w500, fontSize: 16.0)),
                    EvoBox.w8,
                    const CircleAvatar(
                      radius: 4.0,
                      backgroundColor: EvoColor.redDark,
                    ),
                    EvoBox.w4,
                    Text('Gastos',
                        style: EvoTheme.text(context).copyWith(
                            fontWeight: FontWeight.w500, fontSize: 16.0)),
                    // Expanded(
                    //   flex: 2,
                    //   child: ListTile(
                    //     horizontalTitleGap: 0.0,
                    //     contentPadding: EdgeInsets.zero,
                    //     leading: CircleAvatar(
                    //       backgroundColor: chartTitle[0]['color'],
                    //       radius: 5,
                    //     ),
                    //     title: Text(
                    //       '${chartTitle[0]['title']}  ${chartTitle[0]['amount_total']}',
                    //       style: EvoTheme.text(context).copyWith(
                    //           fontWeight: FontWeight.w500, fontSize: 16),
                    //     ),
                    //   ),
                    // ),
                    //  EvoBox.w20,
                    // Expanded(
                    //   flex: 2,
                    //   child: ListTile(
                    //     horizontalTitleGap: 0.0,
                    //     contentPadding: EdgeInsets.zero,
                    //     leading: CircleAvatar(
                    //       backgroundColor: chartTitle[1]['color'],
                    //       radius: 5,
                    //     ),
                    //     title: Text(
                    //       '${chartTitle[1]['title']}  ${ chartTitle[1]['amount_total']}' ,
                    //       style: EvoTheme.text(context).copyWith(
                    //           fontWeight: FontWeight.w500, fontSize: 16),
                    //     ),

                    //   ),
                    // ),
                  ],
                ),
                EvoBox.h10,
                if (EvoResponsive.isLargeWeb(context) ||
                    EvoResponsive.isMediumWeb(context)) ...[
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _totalChart(context)),
                        Expanded(
                          flex: 3,
                          child: _chart(),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  _totalMobileChart(context),
                  EvoBox.h28,
                  Expanded(
                    flex: 2,
                    child: _chart(),
                  ),
                  EvoBox.h28,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const CircleAvatar(
                        radius: 4.0,
                        backgroundColor: EvoColor.primary,
                      ),
                      EvoBox.w4,
                      Text('High', style: EvoTheme.text(context)),
                      EvoBox.w8,
                      const CircleAvatar(
                        radius: 4.0,
                        backgroundColor: EvoColor.redDark,
                      ),
                      EvoBox.w4,
                      Text('Low', style: EvoTheme.text(context)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chart() {
    return LineChart(
      LineChartData(
        minY: 0.0,
        maxY: 200.0,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
                _chartDataOne.length,
                (index) =>
                    FlSpot(index.toDouble(), _chartDataOne[index].toDouble())),
            isCurved: false,
            barWidth: 2,
            color: EvoColor.primary,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: EvoColor.primary.withOpacity(0.2),
            ),
          ),
          LineChartBarData(
            spots: List.generate(
                _chartDataTwo.length,
                (index) =>
                    FlSpot(index.toDouble(), _chartDataTwo[index].toDouble())),
            isCurved: false,
            barWidth: 2,
            dotData: const FlDotData(show: true),
            color: EvoColor.redDark,
            belowBarData: BarAreaData(
              show: true,
              color: EvoColor.redDark.withOpacity(0.2),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            // tooltipBgColor: EvoColor.grey.withOpacity(0.3),
            fitInsideHorizontally: true,
            tooltipRoundedRadius: 8.0,
          ),
        ),
        titlesData: FlTitlesData(
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              reservedSize: 40.0,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 4.0,
                  child: Text(
                    meta.formattedValue,
                    maxLines: 1,
                  ),
                );
              },
              showTitles: true,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 4,
                  child: Text(
                    _bottom[value.toInt()],
                  ),
                );
              },
              showTitles: true,
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(
          drawHorizontalLine: true,
          drawVerticalLine: false,
        ),
      ),
    );
  }

  Widget _totalChart(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${earningAndTotalListItem[0]['producTitle']} - ${earningAndTotalListItem[0]['value']}',
          // '${EvoString.totalEarning} - \$22,081',
          style: EvoTheme.title(context).copyWith(fontSize: 16.0),
        ),
        SizedBox(
          height: 50,
          child: LineChart(
            mainData(_earningChart),
          ),
        ),
        EvoBox.h2,
        Text(
          '${earningAndTotalListItem[1]['producTitle']} - ${earningAndTotalListItem[1]['value']}',
          // '${EvoString.newCustomer} - 1,200',
          style: EvoTheme.title(context).copyWith(fontSize: 16.0),
        ),
        SizedBox(
          height: 50,
          child: LineChart(
            mainData(_customerChart),
          ),
        ),
      ],
    );
  }

  Widget _totalMobileChart(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  '${"EvoString.totalEarning"} - \$22,081',
                  style: EvoTheme.title(context).copyWith(fontSize: 16.0),
                ),
                EvoBox.h16,
                SizedBox(
                  height: 50,
                  child: LineChart(
                    mainData(_earningChart),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '${"EvoString.newCustomer"} - 1,200',
                  style: EvoTheme.title(context).copyWith(fontSize: 16.0),
                ),
                EvoBox.h16,
                SizedBox(
                  height: 50,
                  child: LineChart(
                    mainData(_customerChart),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
