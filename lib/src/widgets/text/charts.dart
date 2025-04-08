import 'package:evochurch/src/constants/app_theme.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/widgets/text/contribution_datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = useState(true);

    return MaterialApp(
      title: 'Church Dashboard',
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Church Dashboard'),
          actions: [
            IconButton(
              icon: Icon(isDarkMode.value ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => isDarkMode.value = !isDarkMode.value,
            ),
          ],
        ),
        body: const ChurchDashboard(),
      ),
    );
  }
}

class ChurchDashboard extends HookWidget {
  const ChurchDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final contributions =
        useState<List<ContributionData>>(_generateContributions());
    final transactions =
        useState<List<TransactionData>>(_generateTransactions());

    final totalDiezmos =
        contributions.value.fold(0, (sum, item) => sum + item.diezmos);
    final totalOffering =
        contributions.value.fold(0, (sum, item) => sum + item.offering);
    final totalDonation =
        contributions.value.fold(0, (sum, item) => sum + item.donation);

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCards(context, totalDiezmos, totalOffering, totalDonation),
          _buildChartWithLegend(context, contributions.value),
          // EvoLayoutResponsive(
          //   mobile: _buildTransactionList(context, transactions.value),
          //   tablet: _buildTransactionList(context, transactions.value),
          //   smallDesktop: const TaskQueue(),
          //   largeDesktop: const TaskQueue(),
          // ),
        ],
      ),
    );
  }

  Widget _buildCards(BuildContext context, int totalDiezmos, int totalOffering,
      int totalDonation) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isSmallScreen
          ? Column(
              children: [
                _buildCard(
                  context,
                  title: 'Diezmos',
                  amount: totalDiezmos,
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.indigo],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.church,
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
                  amount: totalDonation,
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
                    title: 'Diezmos',
                    amount: totalDiezmos,
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.indigo],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: Icons.church,
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
                    icon: Icons.handshake,
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
                    icon: Icons.favorite,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCard(
                    context,
                    title: 'Total Contributions',
                    amount: totalDonation,
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
    required int amount,
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
      BuildContext context, List<ContributionData> contributions) {
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
                  _buildLegendItem(context, 'Diezmos', Colors.blue),
                  const SizedBox(width: 16),
                  _buildLegendItem(context, 'Offering', Colors.green),
                  const SizedBox(width: 16),
                  _buildLegendItem(context, 'Donation', Colors.orange),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: _buildBarChart(contributions),
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

  Widget _buildBarChart(List<ContributionData> contributions) {
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
                if (i >= 0 && i < contributions.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      contributions[i].month,
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
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '\$${value.toInt()}',
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 500,
        ),
        borderData: FlBorderData(show: false),
        barGroups: contributions.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.diezmos.toDouble(),
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
      BuildContext context, List<TransactionData> transactions) {
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

                  switch (transaction.type) {
                    case 'Diezmos':
                      iconData = Icons.church;
                      iconColor = Colors.blue;
                      break;
                    case 'Offering':
                      iconData = Icons.handshake;
                      iconColor = Colors.green;
                      break;
                    case 'Donation':
                      iconData = Icons.favorite;
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
                      transaction.type,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('From: ${transaction.donor}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${transaction.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          transaction.date,
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

  // Data models
  static List<ContributionData> _generateContributions() {
    return [
      ContributionData(
          month: 'Jan', diezmos: 1000, offering: 500, donation: 200),
      ContributionData(
          month: 'Feb', diezmos: 1200, offering: 600, donation: 250),
      ContributionData(
          month: 'Mar', diezmos: 1100, offering: 550, donation: 300),
      ContributionData(
          month: 'Apr', diezmos: 1300, offering: 700, donation: 350),
      ContributionData(
          month: 'May', diezmos: 1400, offering: 800, donation: 400),
      ContributionData(
          month: 'Jun', diezmos: 1500, offering: 900, donation: 450),
      ContributionData(
          month: 'Jul', diezmos: 1600, offering: 1000, donation: 500),
      ContributionData(
          month: 'Aug', diezmos: 1700, offering: 1100, donation: 550),
      ContributionData(
          month: 'Sep', diezmos: 1800, offering: 1200, donation: 600),
      ContributionData(
          month: 'Oct', diezmos: 1900, offering: 1300, donation: 650),
      ContributionData(
          month: 'Nov', diezmos: 2000, offering: 1400, donation: 700),
      ContributionData(
          month: 'Dec', diezmos: 2100, offering: 1500, donation: 750),
    ];
  }

  static List<TransactionData> _generateTransactions() {
    return [
      TransactionData(
          type: 'Diezmos',
          amount: 100,
          date: '2023-10-01',
          donor: 'John Smith'),
      TransactionData(
          type: 'Offering',
          amount: 50,
          date: '2023-10-02',
          donor: 'Maria Garcia'),
      TransactionData(
          type: 'Donation',
          amount: 200,
          date: '2023-10-03',
          donor: 'David Johnson'),
      TransactionData(
          type: 'Diezmos',
          amount: 150,
          date: '2023-10-05',
          donor: 'Sarah Williams'),
      TransactionData(
          type: 'Offering',
          amount: 75,
          date: '2023-10-07',
          donor: 'Michael Brown'),
      TransactionData(
          type: 'Donation',
          amount: 500,
          date: '2023-10-08',
          donor: 'Linda Martinez'),
      TransactionData(
          type: 'Diezmos',
          amount: 120,
          date: '2023-10-10',
          donor: 'Robert Taylor'),
      TransactionData(
          type: 'Offering',
          amount: 60,
          date: '2023-10-12',
          donor: 'Jennifer Lee'),
      TransactionData(
          type: 'Donation',
          amount: 300,
          date: '2023-10-15',
          donor: 'James Anderson'),
      TransactionData(
          type: 'Diezmos',
          amount: 110,
          date: '2023-10-18',
          donor: 'Patricia Wilson'),
    ];
  }
}

// Data models
class ContributionData {
  final String month;
  final int diezmos;
  final int offering;
  final int donation;

  ContributionData({
    required this.month,
    required this.diezmos,
    required this.offering,
    required this.donation,
  });
}

class TransactionData {
  final String type;
  final double amount;
  final String date;
  final String donor;

  TransactionData({
    required this.type,
    required this.amount,
    required this.date,
    required this.donor,
  });
}
