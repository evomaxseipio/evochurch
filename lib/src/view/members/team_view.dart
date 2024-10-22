// Add similar pages for other menu items
import 'package:flutter/material.dart';

class TeamsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Teams',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Team Management',
                      style: Theme.of(context).textTheme.titleLarge),
                  // Add teams content here
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
