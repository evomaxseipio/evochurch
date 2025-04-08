import 'package:flutter/material.dart';

enum StatusType { visita, pending, completed, cancelled, error }

class StatusChip extends StatelessWidget {
  final String status;
  final String? customLabel;

  const StatusChip({
    super.key,
    required this.status,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        // color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _getStatusColor(),
          width: 1,
        ),
      ),
      child: Text(
        customLabel ?? status.toUpperCase(),
        style: TextStyle(
          color: _getStatusColor(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case 'Visita':
        return Colors.green;
      case 'Pastor':
        return Colors.orange;
      case 'Miembro':
        return Colors.blue;
      case 'Primaria':
        return Colors.blueAccent;
      case 'Secundaria':
        return Colors.greenAccent;
      case 'Inactiva':
        return Colors.redAccent;
      case 'Activo':
        return Colors.purpleAccent.shade100;
      // case StatusType.completed:
      //   return Colors.blue;
      // case StatusType.cancelled:
      //   return Colors.grey;
      // case StatusType.error:
      //   return Colors.red;
      default:
        return Colors.blueAccent; // or any default color
    }
  }
}
