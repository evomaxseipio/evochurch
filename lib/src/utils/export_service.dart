import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:typed_data';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

class CollectionExportService {
  /// Export a list of data to Excel (Mobile)
  static Future<void> exportToExcel({
    required List<Map<String, dynamic>> data,
    required List<String> headers,
    required Map<String, String> columnFormats,
    String? fileName,
    BuildContext? context,
    bool share = false,
  }) async {
    // Create an Excel document
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Add headers
    for (var col = 0; col < headers.length; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col + 1, rowIndex: 1))
        ..value = TextCellValue(headers[col])
        ..cellStyle = CellStyle(
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
          backgroundColorHex: ExcelColor.blue,
        );
    }

    // Add data rows
    for (var row = 0; row < data.length; row++) {
      final item = data[row];
      for (var col = 0; col < headers.length; col++) {
        final header = headers[col];
        final value = item[header]?.toString() ?? '';

        // Apply formatting if specified
        if (columnFormats.containsKey(header)) {
          final format = columnFormats[header]!;
          if (format == 'date') {
            final date = DateTime.tryParse(value);
            if (date != null) {
              sheet
                      .cell(CellIndex.indexByColumnRow(
                          columnIndex: col, rowIndex: row + 1))
                      .value =
                  TextCellValue(DateFormat('MMM dd, yyyy').format(date));
              continue;
            }
          } else if (format == 'currency') {
            final amount = double.tryParse(value) ?? 0.0;
            sheet.cell(
                CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 2))
              ..value = TextCellValue(
                  NumberFormat.currency(symbol: '\$').format(amount))
              ..cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Right);
            continue;
          }
        }

        // Default value
        sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1))
          ..value = TextCellValue(value);
      }
    }

    // Auto-size columns
    for (var i = 0; i < headers.length; i++) {
      sheet.setColumnWidth(i, 15.0);
    }

    // Encode the Excel file as bytes
    final fileBytes = excel.encode();
    if (fileBytes == null) {
      throw Exception('Failed to generate Excel file');
    }

    // Save to device storage
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, fileName ?? 'export.xlsx');
    final file = File(filePath);
    await file.writeAsBytes(fileBytes);

    // Handle the exported file (open or share)
    await handleExportedFile(context, filePath, share: share);
  }

  /// Export a list of data to PDF (Mobile)
  static Future<void> exportToPDF({
    required List<Map<String, dynamic>> data,
    required List<String> headers,
    required Map<String, String> columnFormats,
    String? fileName,
    String? title,
    BuildContext? context,
    bool share = false,
  }) async {
    // Create a PDF document
    final pdf = pw.Document();

    // Prepare data for table
    final List<List<String>> tableData = data.map((item) {
      return headers.map((header) {
        final value = item[header]?.toString() ?? '';

        // Apply formatting if specified
        if (columnFormats.containsKey(header)) {
          final format = columnFormats[header]!;
          if (format == 'date') {
            final date = DateTime.tryParse(value);
            if (date != null) {
              return DateFormat('MMM dd, yyyy').format(date);
            }
          } else if (format == 'currency') {
            final amount = double.tryParse(value) ?? 0.0;
            return NumberFormat.currency(symbol: '\$').format(amount);
          }
        }

        // Default value
        return value;
      }).toList();
    }).toList();

    // Add content to the PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (pw.Context context) {
          return pw.Header(
            level: 0,
            child: pw.Text(
              title ?? 'Export Report',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          );
        },
        build: (pw.Context context) => [
          pw.Table.fromTextArray(
            headers: headers,
            data: tableData,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
            cellAlignments: {
              for (var i = 0; i < headers.length; i++)
                i: pw.Alignment.centerLeft,
            },
            cellPadding: const pw.EdgeInsets.all(5),
          ),
        ],
      ),
    );

    // Save the PDF to device storage
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, fileName ?? 'export.pdf');
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Handle the exported file (open or share)
    await handleExportedFile(context, filePath, share: share);
  }

  /// Handle file after export (open/share)
  static Future<void> handleExportedFile(
    BuildContext? context,
    String filePath, {
    bool share = false,
  }) async {
    if (share) {
      await Share.shareXFiles([XFile(filePath)], text: 'Exported File');
    } else {
      if (context != null && context.mounted) {
        final result = await OpenFile.open(filePath);
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Could not open the file: ${result.message}')),
          );
        }
      }
    }
  }
}
