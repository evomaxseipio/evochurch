import 'package:evochurch/src/constants/text_editing_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Information Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const Scaffold(
        body: SafeArea(
          child: PersonalInformationForm(),
        ),
      ),
    );
  }
}

class PersonalInformationForm extends HookWidget {
  const PersonalInformationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useState(GlobalKey<FormState>());
    final _memberControllers = useState<Map<String, TextEditingController>>({});
    final _addressControllers =
        useState<Map<String, TextEditingController>>({});
    final dropdownValues = useState<Map<String, String>>({});

    // Initialize controllers
    useEffect(() {
      for (var field in membersControllers) {
        _memberControllers.value[field] = TextEditingController();
      }

      for (var field in addressControllers) {
        _addressControllers.value[field] = TextEditingController();
      }

      // Set initial values for dropdowns
      dropdownValues.value = {
        'gender': 'Male',
        'maritalStatus': 'Single',
        'idType': 'Passport',
        'memberStatus': 'Active Member',
        'accountStatus': 'Active',
      };

      // Set some initial values for testing
      _memberControllers.value['firstName']?.text = 'Rafiqur';
      _memberControllers.value['lastName']?.text = 'Rahman';
      _memberControllers.value['nickname']?.text = 'Rafi';
      _memberControllers.value['dateOfBirth']?.text = 'May 15, 1990';
      _memberControllers.value['nationality']?.text = 'British';
      _memberControllers.value['idNumber']?.text = 'AB123456';
      _memberControllers.value['country']?.text = 'United Kingdom';
      _memberControllers.value['cityState']?.text = 'Leeds, East London';
      _memberControllers.value['postalCode']?.text = 'ERT 2354';
      _memberControllers.value['taxId']?.text = 'AS4564756';

      return () {
        for (var controller in _memberControllers.value.values) {
          controller.dispose();
        }
      };
    }, []);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey.value,
        child: Column(
          children: [
            _buildPersonalInfoSection(
                context, _memberControllers.value, dropdownValues.value),
            const SizedBox(height: 20),
            _buildAddressSection(context, _memberControllers.value),
          ],
        ),
      ),
    );
  }
}

Widget _buildPersonalInfoSection(
  BuildContext context,
  Map<String, TextEditingController> controllers,
  Map<String, String> dropdownValues,
) {
  return Card(
    elevation: 2,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Personal Information'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child:
                        _buildInfoField('First Name', 'firstName', controllers),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:
                        _buildInfoField('Last Name', 'lastName', controllers),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoField('Nickname', 'nickname', controllers),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                        'Date of Birth', 'dateOfBirth', controllers, context),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                        'Gender', 'gender', ['Male', 'Female'], dropdownValues),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      'Marital Status',
                      'maritalStatus',
                      ['Single', 'Married', 'Divorced', 'Widowed'],
                      dropdownValues,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoField(
                        'Nationality', 'nationality', controllers),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      'ID Type',
                      'idType',
                      ['Passport', 'ID Card'],
                      dropdownValues,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:
                        _buildInfoField('ID Number', 'idNumber', controllers),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      'Member Status',
                      'memberStatus',
                      ['Active Member', 'Inactive Member'],
                      dropdownValues,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      'Account Status',
                      'accountStatus',
                      ['Active', 'Inactive'],
                      dropdownValues,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildAddressSection(
  BuildContext context,
  Map<String, TextEditingController> controllers,
) {
  return Card(
    elevation: 1,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Address'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildInfoField('Country', 'country', controllers),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:
                        _buildInfoField('City/State', 'cityState', controllers),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoField(
                        'Postal Code', 'postalCode', controllers),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoField('TAX ID', 'taxId', controllers),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildSectionHeader(String title) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      // color: Colors.white,
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // Add edit functionality
          },
        ),
      ],
    ),
  );
}

Widget _buildInfoField(
  String label,
  String field,
  Map<String, TextEditingController> controllers,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      const SizedBox(height: 4),
      TextFormField(
        controller: controllers[field],
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    ],
  );
}

Widget _buildDateField(
  String label,
  String field,
  Map<String, TextEditingController> controllers,
  BuildContext context,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      const SizedBox(height: 4),
      TextFormField(
        controller: controllers[field],
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (date != null) {
            controllers[field]?.text = DateFormat('MMM dd, yyyy').format(date);
          }
        },
      ),
    ],
  );
}

Widget _buildDropdownField(
  String label,
  String field,
  List<String> items,
  Map<String, String> dropdownValues,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      const SizedBox(height: 4),
      DropdownButtonFormField<String>(
        value: dropdownValues[field],
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            dropdownValues[field] = value;
          }
        },
        validator: (value) => value == null ? 'Please select $label' : null,
      ),
    ],
  );
}
