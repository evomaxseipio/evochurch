import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/widgets/widget_index.dart';

class RevenueView extends HookWidget {
  const RevenueView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: GridView.builder(
          gridDelegate:
              Responsive.isMobile(context) || Responsive.isTablet(context)
                  ? const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // Changed to 1 for mobile
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 120,
                    )
                  : MediaQuery.of(context).size.width < 1555
                      ? const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1, // Changed to 1 for mobile
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 120,
                        )
                      : MediaQuery.of(context).size.width > 1500
                          ? const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              mainAxisExtent: 120,
                            )
                          : SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent:
                                  MediaQuery.of(context).size.width * 0.24,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              mainAxisExtent: 120,
                            ),
          itemCount: _listItem.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _listContainer(
              context: context,
              productTitle: _listItem[index]['producTitle'],
              value: _listItem[index]['value'],
              index: index,
            );
          },
        ),
      ),
    );
  }

  Widget _listContainer({
    required BuildContext context,
    required String productTitle,
    required String value,
    required int index,
  }) {
    return EvoHover(builder: (isHover) {
      return EvoWhiteCard(
        shadowColor: ColorConst.primary,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(10.0),
        // ),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    productTitle,
                    style: EvoTheme.title(context),
                  ),
                  EvoBox.h10,
                  Row(
                    children: [
                      Text(
                        value,
                        style: EvoTheme.title(context)
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      EvoBox.w10,
                      if (index == 2 || index == 3) ...[
                        Icon(
                          CupertinoIcons.sort_down,
                          color: ColorConst.error,
                        ),
                      ] else ...[
                        Icon(
                          CupertinoIcons.sort_up,
                          color: ColorConst.success,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              Icon(
                CupertinoIcons.chart_bar_alt_fill,
                size: 60.0,
                color: sliderColor(index).withOpacity(0.5),
              )
            ],
          ),
        ),
      );
    });
  }
}

Color sliderColor(
  int index,
) {
  if (index == 0) {
    return EvoColor.primary;
  } else if (index == 1) {
    return const Color(0xff3CC2AE);
  } else if (index == 2) {
    return EvoColor.error;
  } else {
    return EvoColor.appleDark; // Color.fromARGB(255, 4, 110, 240);
  }
}

final List<Map<String, dynamic>> _listItem = [
  {
    'id': 0,
    'producTitle': 'Ingresos Totales',
    'value': '\$516,000.90',
  },
  {
    'id': 1,
    'producTitle': 'Ingresos del Mes',
    'value': '\$45,800.76',
  },
  {
    'id': 2,
    'producTitle': 'Pagos en Atraso',
    'value': '\$28,890.45',
  },
  {
    'id': 3,
    'producTitle': 'Pagos del Mes',
    'value': '\$65,849.00',
  },
];
