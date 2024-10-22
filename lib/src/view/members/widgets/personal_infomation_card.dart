import 'package:flutter/material.dart';

class InformationCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback? onEdit;

  const InformationCard({super.key, 
    required this.title,
    required this.children,
    this.onEdit,
    
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
               /*  IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ), */
              ],
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}
