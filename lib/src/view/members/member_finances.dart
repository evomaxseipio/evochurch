import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/model/member_finance_model.dart';
import 'package:evochurch/src/model/member_model.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view_model/index_view_model.dart';
import 'package:evochurch/src/widgets/text/contribution_datatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MemberFinances extends HookWidget {
  final Member? member;
  const MemberFinances({this.member, super.key});

  @override
  Widget build(BuildContext context) {
    final memberViewModel =
        Provider.of<MembersViewModel>(context, listen: true);
    final financeData = useState<Map<String, dynamic>>({});
    final collectionHeader = useState<CollectionHeaderDetails?>(null);
    final collectionDetails = useState<List<CollectionList>>([]);
    final monthlyContributions = useState<List<CollectionChartData>>([]);
    final statusCode = useState<int>(0);
    final messageStatus = useState<String>('');
    final loading = useState<bool>(false);

    // Animation controllers for smooth transitions
    final fadeAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 800), // Controls fade speed
      initialValue: 1.0,
    );

    final fadeAnimation = useAnimation(CurvedAnimation(
      parent: fadeAnimationController,
      curve: Curves.easeInOut, // Smooth curve for transitions
    ));

    Future<void> getFinanceData() async {
      try {
        loading.value = true;
        // Slow fade out
        await fadeAnimationController.animateTo(
          0.3, // Fade to 30% opacity instead of fully invisible
          duration: const Duration(milliseconds: 400), // Slower fade out
          curve: Curves.easeOut,
        );

        financeData.value =
            await memberViewModel.getFinancialByMemberId(member!.memberId!);

        if (financeData.value['status_code'] == 204) {
          statusCode.value = 204;
          messageStatus.value = financeData.value['message'];
        } else {
          final memberFinanceData =
              MemberFinanceData.fromJson(memberViewModel.memberFinances);
          statusCode.value = memberFinanceData.statusCode;
          messageStatus.value = memberFinanceData.message;
          collectionHeader.value = memberFinanceData.collectionHeaderDetails;
          collectionDetails.value = memberFinanceData.collectionList;
          monthlyContributions.value = memberFinanceData.collectionChartData;
        }

        // Brief pause to ensure data is processed
        await Future.delayed(const Duration(milliseconds: 100));
        loading.value = false;
      } catch (e) {
        loading.value = false;
        debugPrint(e.toString());

        // Restore visibility if error occurs
        fadeAnimationController.animateTo(1.0,
            duration: const Duration(milliseconds: 300));
      }
    }

    useEffect(() {
      // Subscribe to data change notifications
      final subscription = memberViewModel.onDataChanged.listen((_) {
        debugPrint('Data changed, refreshing finance data...');
        getFinanceData();
      });

      // Fetch initial data
      getFinanceData();

      // Cleanup subscription when widget disposes
      return () => subscription.cancel();
    }, [memberViewModel, member]);

    return SingleChildScrollView(
      child: loading.value
          ? _buildLoadingUI(context) 
          : statusCode.value == 204
              ? Center(
                  child: Text(
                    messageStatus.value,
                    style: const TextStyle(fontSize: 20),
                  ),
                )
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.05),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    key: ValueKey<String>(
                        'financeData-${DateTime.now().millisecondsSinceEpoch}'),
                    children: [
                      _buildCards(
                          context,
                          collectionHeader.value!.tithesAmount.toString(),
                          collectionHeader.value!.offeringAmount.toString(),
                          collectionHeader.value!.donationAmount.toString(),
                          collectionHeader.value!.totalContributions
                              .toString()),
                      _buildChartWithLegend(
                          context, monthlyContributions.value),
                      EvoLayoutResponsive(
                        mobile: _buildTransactionList(
                            context, collectionDetails.value),
                        tablet: _buildTransactionList(
                            context, collectionDetails.value),
                        smallDesktop:
                            TaskQueue(collectionDetails.value, member!),
                        largeDesktop:
                            TaskQueue(collectionDetails.value, member!),
                      ),
                    ],
                  ),
                ),
    );
  }

  // Custom loading UI with subtle animation
  Widget _buildLoadingUI(BuildContext context) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading financial data...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildCards(BuildContext context, String totalDiezmos,
      String totalOffering, String totalDonation, String totalContributions) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isSmallScreen
          ? Column(
              children: [
                _buildCard(
                  context,
                  title: 'Tithes',
                  amount: totalDiezmos,
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.indigo],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.volunteer_activism_outlined,
                ),
                const SizedBox(height: 16),
                _buildCard(
                  context,
                  title: 'Offering',
                  amount: totalOffering,
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.handshake,
                ),
                const SizedBox(height: 16),
                _buildCard(
                  context,
                  title: 'Donation',
                  amount: totalDonation,
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.favorite,
                ),
                const SizedBox(height: 16),
                _buildCard(
                  context,
                  title: 'Total Contributions',
                  amount: totalContributions,
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.monetization_on_outlined,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: _buildCard(
                    context,
                    title: 'Tithes',
                    amount: totalDiezmos,
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.indigo],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: EvoIcons.tithes.icon,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCard(
                    context,
                    title: 'Offering',
                    amount: totalOffering,
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.teal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: EvoIcons.offering.icon,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCard(
                    context,
                    title: 'Donation',
                    amount: totalDonation,
                    gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: EvoIcons.donation.icon,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCard(
                    context,
                    title: 'Total Contributions',
                    amount: totalContributions,
                    gradient: const LinearGradient(
                      colors: [Colors.purple, Colors.deepPurple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: Icons.monetization_on_outlined,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String amount,
    required Gradient gradient,
    required IconData icon,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon,
                size:
                    Responsive.isMobile(context) || Responsive.isTablet(context)
                        ? 40
                        : 60,
                color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatCurrency(amount.toString()),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.isMobile(context) ||
                                  Responsive.isTablet(context)
                              ? 20
                              : 24,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartWithLegend(
      BuildContext context, List<CollectionChartData> collectionData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Monthly Contributions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(context, 'Tithes', Colors.blue),
                  const SizedBox(width: 16),
                  _buildLegendItem(context, 'Offering', Colors.green),
                  const SizedBox(width: 16),
                  _buildLegendItem(context, 'Donation', Colors.orange),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: _buildBarChart(collectionData),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String title, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(title),
      ],
    );
  }

  Widget _buildBarChart(List<CollectionChartData> collectionData) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            // tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String category = '';
              switch (rodIndex) {
                case 0:
                  category = 'Diezmos';
                  break;
                case 1:
                  category = 'Offering';
                  break;
                case 2:
                  category = 'Donation';
                  break;
              }
              return BarTooltipItem(
                '$category: \$${rod.toY.toInt()}',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i >= 0 && i < collectionData.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      collectionData[i].month,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Text(
                    '\$${value.toInt()}',
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
              reservedSize: 45,
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: false,
          drawHorizontalLine: true,
          horizontalInterval: 500,
        ),
        borderData: FlBorderData(show: false),
        barGroups: collectionData.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.tithes.toDouble(),
                color: Colors.blue,
                width: 12,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              BarChartRodData(
                toY: entry.value.offering.toDouble(),
                color: Colors.green,
                width: 12,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              BarChartRodData(
                toY: entry.value.donation.toDouble(),
                color: Colors.orange,
                width: 12,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionList(
      BuildContext context, List<CollectionList> transactions) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Member Contributions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: transactions.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  IconData iconData;
                  Color iconColor;

                  switch (transaction.collectionType) {
                    case 1: //'Tithes'
                      iconData = EvoIcons.tithes.icon;
                      iconColor = Colors.blue;
                      break;
                    case 2: //'Offering'
                      iconData = EvoIcons.offering.icon;
                      iconColor = Colors.green;
                      break;
                    case 3: //'Donation'
                      iconData = EvoIcons.donation.icon;
                      iconColor = Colors.orange;
                      break;
                    default:
                      iconData = Icons.attach_money;
                      iconColor = Colors.grey;
                  }

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: iconColor.withOpacity(0.2),
                      child: Icon(iconData, color: iconColor),
                    ),
                    title: Text(
                      transaction.collectionTypeName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(transaction.collectionDate.toString()),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${transaction.collectionAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          formatDate(transaction.collectionDate.toString()),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
