import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const DashboardApp());
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Dashboard(),
      ),
    );
  }
}

class Dashboard extends HookWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final sidebarOpen = useState(false);

    return Row(
      children: [
        if (sidebarOpen.value)
          Sidebar(
            isOpen: sidebarOpen.value,
            toggleSidebar: () => sidebarOpen.value = !sidebarOpen.value,
          ),
        Expanded(
          child: Column(
            children: [
              // Header
              Header(
                  toggleSidebar: () => sidebarOpen.value = !sidebarOpen.value),
              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Dashboard cards
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          childAspectRatio: 2.5,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                          children: const [
                            DashboardCard(
                              title: "Total Members",
                              value: "250",
                              icon: Icons.people,
                              color: Colors.blue,
                              trend: 5,
                            ),
                            DashboardCard(
                              title: "Upcoming Events",
                              value: "3",
                              icon: Icons.event,
                              color: Colors.green,
                            ),
                            DashboardCard(
                              title: "This Month's Donations",
                              value: "\$5,000",
                              icon: Icons.attach_money,
                              color: Colors.yellow,
                              trend: -2,
                            ),
                            DashboardCard(
                              title: "Active Volunteers",
                              value: "45",
                              icon: Icons.volunteer_activism,
                              color: Colors.purple,
                              trend: 10,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Chart and Events
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AttendanceChart(),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: UpcomingEvents(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Donations and Quick Actions
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RecentDonations(),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: QuickActions(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Sidebar extends StatelessWidget {
  final bool isOpen;
  final VoidCallback toggleSidebar;

  const Sidebar({super.key, required this.isOpen, required this.toggleSidebar});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.blue,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Menu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.white),
            title:
                const Text("Dashboard", style: TextStyle(color: Colors.white)),
            onTap: toggleSidebar,
          ),
          ListTile(
            leading: const Icon(Icons.people, color: Colors.white),
            title: const Text("Members", style: TextStyle(color: Colors.white)),
            onTap: toggleSidebar,
          ),
          // Add more items here...
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final VoidCallback toggleSidebar;

  const Header({super.key, required this.toggleSidebar});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Church Admin Dashboard"),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: toggleSidebar,
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final int? trend;

  const DashboardCard({super.key, 
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 8),
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          if (trend != null)
            Text(
              '${trend! > 0 ? '▲' : '▼'} ${trend!.abs()}% from last month',
              style: TextStyle(color: trend! > 0 ? Colors.green : Colors.red),
            ),
        ],
      ),
    );
  }
}

class AttendanceChart extends StatelessWidget {
  const AttendanceChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Monthly Attendance",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: const FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 4,
                    dotData: const FlDotData(show: false),
                    spots: const [
                      FlSpot(0, 200),
                      FlSpot(1, 220),
                      FlSpot(2, 210),
                      FlSpot(3, 240),
                      FlSpot(4, 280),
                      FlSpot(5, 250),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpcomingEvents extends StatelessWidget {
  const UpcomingEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
          ),
        ],
      ),
      child: const Column(
        children: [
          Text(
            "Upcoming Events",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ListTile(
            title: Text("Sunday Service"),
            subtitle: Text("Tomorrow, 10:00 AM"),
          ),
          ListTile(
            title: Text("Youth Group Meeting"),
            subtitle: Text("Wed, 6:30 PM"),
          ),
          ListTile(
            title: Text("Community Outreach"),
            subtitle: Text("Sat, 9:00 AM"),
          ),
        ],
      ),
    );
  }
}

class RecentDonations extends StatelessWidget {
  const RecentDonations({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
          ),
        ],
      ),
      child: const Column(
        children: [
          Text(
            "Recent Donations",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ListTile(
            title: Text("John Doe"),
            subtitle: Text("\$100 on Sep 10"),
          ),
          ListTile(
            title: Text("Jane Smith"),
            subtitle: Text("\$50 on Sep 8"),
          ),
        ],
      ),
    );
  }
}

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 5.0),
        ],
      ),
      child: const Column(
        children: [
          Text(
            "Quick Actions",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ListTile(
            title: Text("Add New Member"),
            leading: Icon(Icons.person_add),
            onTap: null,
          ),
          ListTile(
            title: Text("Schedule Event"),
            leading: Icon(Icons.event),
            onTap: null,
          ),
        ],
      ),
    );
  }
}
