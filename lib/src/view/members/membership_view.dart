// Add pages for each menu item
import 'package:flutter/material.dart';



class MembershipPage extends StatelessWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Membership',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Membership Details',
                      style: Theme.of(context).textTheme.titleLarge),
                  // Add membership content here
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
