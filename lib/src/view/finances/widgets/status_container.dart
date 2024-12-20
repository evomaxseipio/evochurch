import 'package:flutter/material.dart';

Widget statusButton({required String status}) {
  Color color = getStatusColor(status);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      border: Border.all(width: 1, color: color),
    ),
    child: Text(
      status,
      softWrap: true,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
      ),
    ),
  );
}

getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case "approved":
      return Colors.green;
    case "pending":
      return Colors.orange;
    case "rejected":
      return Colors.red;
    default:
      return Colors.blue;
  }
}
