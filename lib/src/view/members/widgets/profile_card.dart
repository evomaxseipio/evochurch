import 'package:flutter/material.dart';

import '../../../model/members_model.dart';

class ProfileCard extends StatelessWidget {
  final MemberProfile profile;
  final VoidCallback onEdit;

  const ProfileCard({super.key, 
    required this.profile,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue[100],
              child: Text(
                '${profile.firstName[0]}${profile.lastName[0]}',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${profile.firstName} ${profile.lastName}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    profile.role,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    profile.location,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
