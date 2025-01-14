import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

  // Error response model
  class ErrorResponse {
    final String title;
    final String message;
    final bool isCritical;

    ErrorResponse({
      required this.title,
      required this.message,
      this.isCritical = false,
    });
  }

class PostgresErrorHandler {
  // Common Postgres error codes
  static const String FOREIGN_KEY_VIOLATION = '23503';
  static const String UNIQUE_VIOLATION = '23505';
  static const String CHECK_VIOLATION = '23514';
  static const String NOT_NULL_VIOLATION = '23502';
  static const String CUSTOM_ERROR = 'P0001';
  static const String INSUFFICIENT_PRIVILEGE = '42501';
  static const String UNDEFINED_COLUMN = '42703';
  static const String UNDEFINED_TABLE = '42P01';
  static const String DIVISION_BY_ZERO = '22012';



  // Main error handling method
  static ErrorResponse handleError(PostgrestException error) {
    switch (error.code) {
      case FOREIGN_KEY_VIOLATION:
        return ErrorResponse(
          title: 'Reference Error',
          message: 'This record cannot be modified because it is referenced by other data.',
        );

      case UNIQUE_VIOLATION:
        return ErrorResponse(
          title: 'Duplicate Entry',
          message: 'This record already exists. Please modify your input.',
        );

      case CHECK_VIOLATION:
        return ErrorResponse(
          title: 'Validation Error',
          message: 'The provided data fails to meet the required conditions.',
        );

      case NOT_NULL_VIOLATION:
        return ErrorResponse(
          title: 'Missing Data',
          message: 'Please fill in all required fields.',
        );

      case CUSTOM_ERROR:
        // Handle custom database errors (like from triggers)
        if (error.message.contains('Insufficient funds')) {
          return _handleInsufficientFunds(error.message);
        }
        return ErrorResponse(
          title: 'Custom Error',
          message: error.message ?? 'A custom database error occurred.',
        );

      case INSUFFICIENT_PRIVILEGE:
        return ErrorResponse(
          title: 'Access Denied',
          message: 'You don\'t have permission to perform this action.',
          isCritical: true,
        );

      case UNDEFINED_COLUMN:
        return ErrorResponse(
          title: 'System Error',
          message: 'Invalid database column reference.',
          isCritical: true,
        );

      case UNDEFINED_TABLE:
        return ErrorResponse(
          title: 'System Error',
          message: 'Invalid database table reference.',
          isCritical: true,
        );

      case DIVISION_BY_ZERO:
        return ErrorResponse(
          title: 'Calculation Error',
          message: 'Invalid mathematical operation: division by zero.',
        );

      default:
        return ErrorResponse(
          title: 'Database Error',
          message: error.message ?? 'An unexpected database error occurred.',
          isCritical: true,
        );
    }
  }

  // Helper method to parse insufficient funds error
  static ErrorResponse _handleInsufficientFunds(String errorMessage) {
    // Extract balance using RegExp
    final balanceRegExp = RegExp(r'Available balance: (-?\d+\.?\d*)');
    final match = balanceRegExp.firstMatch(errorMessage);
    final balance = match?.group(1) != null 
        ? double.parse(match!.group(1)!) 
        : null;

    return ErrorResponse(
      title: 'Insufficient Funds',
      message: 'Insufficient funds available. Current balance: \$${balance?.toStringAsFixed(2) ?? '0.00'}',
    );
  }

  // Show error dialog
  static void showErrorDialog(BuildContext context, PostgrestException error) {
    final errorResponse = handleError(error);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(errorResponse.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(errorResponse.message),
            if (errorResponse.isCritical) ...[
              const SizedBox(height: 16),
              const Text(
                'Please contact support if this error persists.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Method to log errors (you can implement your own logging logic)
  static void logError(PostgrestException error, StackTrace? stackTrace) {
    // Add your logging logic here (e.g., Sentry, Firebase Crashlytics, etc.)
    print('Database Error: ${error.code} - ${error.message}');
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
  }
}