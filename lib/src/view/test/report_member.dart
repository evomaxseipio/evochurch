import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Member Report',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MemberReportScreen(),
    );
  }
}


class Member {
  final String name;
  final String role;
  final String nationality;
  final String email;
  final String phone;
  final String dateOfBirth;

  Member({
    required this.name,
    required this.role,
    required this.nationality,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
  });
}

class MemberReportScreen extends HookWidget {
  const MemberReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final members = useState<List<Member>>(_generateMembers());
    final isLoading = useState<bool>(false);

    Future<void> _printReport() async {
      isLoading.value = true;
      final doc = pw.Document();

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (pw.Context context) {
            return _buildPdfContent(members.value);
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
      );
      isLoading.value = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _printReport,
          ),
        ],
      ),
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Nationality')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Date of Birth')),
                ],
                rows: members.value.map((member) {
                  return DataRow(cells: [
                    DataCell(Text(member.name)),
                    DataCell(Text(member.role)),
                    DataCell(Text(member.nationality)),
                    DataCell(Text(member.email)),
                    DataCell(Text(member.phone)),
                    DataCell(Text(member.dateOfBirth)),
                  ]);
                }).toList(),
              ),
            ),
    );
  }

  pw.Widget _buildPdfContent(List<Member> members) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Header(
            level: 0,
            child: pw.Text('Member Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            context: null,
            headers: ['Name', 'Role', 'Nationality', 'Email', 'Phone', 'Date of Birth'],
            data: members.map((member) => [
              member.name,
              member.role,
              member.nationality,
              member.email,
              member.phone,
              member.dateOfBirth,
            ]).toList(),
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
            cellHeight: 30,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerLeft,
              3: pw.Alignment.centerLeft,
              4: pw.Alignment.centerLeft,
              5: pw.Alignment.centerLeft,
            },
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Generated on: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  static List<Member> _generateMembers() {
    return [
      Member(
        name: 'Adrian Rodriguez',
        role: 'MEMBRO REGULAR',
        nationality: 'Dominicana',
        email: 'adrian@gmail.com',
        phone: '333',
        dateOfBirth: '28/10/2024',
      ),
      Member(
        name: 'Aqapito Pascual',
        role: 'EVANGELISTA',
        nationality: 'Dominicana',
        email: 'ricky@gmail.com',
        phone: '8592',
        dateOfBirth: '28/10/2024',
      ),
      Member(
        name: 'Alba Hellinger',
        role: 'CONSEJERO ESPIRITUAL',
        nationality: 'Dominicana',
        email: 'alba@gmail.com',
        phone: '8299908990',
        dateOfBirth: '17/01/1990',
      ),
      Member(
        name: 'Arelis Mateo',
        role: 'VISITA',
        nationality: 'Dominicana',
        email: 'arelis@gmail.com',
        phone: '2322',
        dateOfBirth: '28/10/2024',
      ),
      Member(
        name: 'Bismarrels Pena Cornielle',
        role: 'LÍDER DE MINISTERIO',
        nationality: 'Dominicana',
        email: 'bismarrelis@gmail.com',
        phone: '8298660987',
        dateOfBirth: '17/10/2024',
      ),
      Member(
        name: 'Bryan Beras Castillo',
        role: 'PASTOR',
        nationality: 'Dominicana',
        email: 'bryan@gmail.com',
        phone: '8098569874',
        dateOfBirth: '22/10/2024',
      ),
      Member(
        name: 'Carlos Paesés',
        role: 'VISITA',
        nationality: 'Venezolana',
        email: 'carlos@abc.com',
        phone: '8298889685',
        dateOfBirth: '22/10/2024',
      ),
      Member(
        name: 'Felix Mercedes',
        role: 'MEMBRO REGULAR',
        nationality: 'Dominicana',
        email: 'fmercedes@gmail.com',
        phone: '3333',
        dateOfBirth: '13/03/2017',
      ),
      Member(
        name: 'Jhon Eder',
        role: 'BACONO',
        nationality: 'Haitiana',
        email: '',
        phone: '895',
        dateOfBirth: '30/10/2024',
      ),
      Member(
        name: 'John Doe',
        role: 'VISITA',
        nationality: 'Guatemalteco',
        email: 'a@abc.com',
        phone: '2',
        dateOfBirth: '16/10/2024',
      ),
    ];
  }
}
