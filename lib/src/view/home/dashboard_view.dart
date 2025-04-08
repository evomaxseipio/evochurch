import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/constants/sizedbox.dart';
import 'package:evochurch/src/utils/evo_responsive.dart';
import 'package:evochurch/src/view/home/debt_list_view.dart';
import 'package:evochurch/src/view/home/debt_percent_pie_chart.dart';
import 'package:evochurch/src/view/home/income_debt_overview.dart';
import 'package:evochurch/src/view/home/revenue_view.dart';
import 'package:evochurch/src/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DashboardView extends HookWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: EvoColor.lightBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Add your dashboard content here
            EvoBox.h20,
            const RevenueView(),
            EvoBox.h12,

            if (EvoResponsive.isMediumWeb(context) &&
                MediaQuery.sizeOf(context).width > 760) ...{
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const Expanded(
                  //   flex: 3,
                  //   child: ProductOverview(),

                  // ),
                  Expanded(
                    flex: 7,
                    child: IncomeDebtOverview(),
                  ),
                  EvoBox.w10,
                ],
              ),
            } else ...{
              Column(
                children: [
                  IncomeDebtOverview(),
                  EvoBox.h10,
                  // _attributesAnalyticsChart(context),
                ],
              )
            },

            EvoBox.h12,
            if (EvoResponsive.isLargeWeb(context) ||
                EvoResponsive.isMediumWeb(context)) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(flex: 2, child: DebtListView()),
                    EvoBox.w12,
                    Expanded(
                        child: EvoWhiteCard(
                            child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 30),
                          child: Text(
                            'Porcentaje de Pagos',
                            style: EvoTheme.title(context)
                                .copyWith(fontSize: 18.0),
                          ),
                        ),
                        const SizedBox(
                          height: 430,
                          child: Padding(
                            padding: EdgeInsets.only(left: 28.0, right: 8.0),
                            child: DebtPercentPieChart(),
                          ),
                        ),
                      ],
                    ))),
                  ],
                ),
              ),
            ] else ...[
              Column(
                children: [
                  const DebtListView(),
                  EvoBox.h12,
                  const EvoWhiteCard(child: DebtPercentPieChart()),
                ],
              ),
            ],
            EvoBox.h12,
          ],
        ),
      ),
    );
  }
}
