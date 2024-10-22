import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Material App Bar'),
          ),
          body: const EmployeeRegistrationForm()),
    );
  }
}

class EmployeeRegistrationForm extends HookWidget {
  const EmployeeRegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useState(GlobalKey<FormState>());
    final selectedImage = useState<File?>(null);
    final scrollController = useScrollController();
    final isSmallScreen = MediaQuery.of(context).size.width < 900;

    // Form controllers
    final controllers = useState<Map<String, TextEditingController>>({});
    final dropdownValues = useState<Map<String, String?>>({});

    // Initialize controllers
    useEffect(() {
      final fields = [
        'firstName',
        'lastName',
        'dateOfBirth',
        'gender',
        'nationality',
        'identificationType',
        'identificationNumber',
        'address',
        'city',
        'state',
        'country',
        'email',
        'phoneNumber',
        'emergencyContactName',
        'emergencyContactRelationship',
        'emergencyContactPhone',
        'emergencyContactEmail',
        'admissionDate',
        'salary',
        'rolName',
        'department',
        'skillsAndTalents',
        'notes'
      ];

      for (var field in fields) {
        controllers.value[field] = TextEditingController();
      }
      return () {
        for (var controller in controllers.value.values) {
          controller.dispose();
        }
      };
    }, []);

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    }

    // Move all builder functions to the top
    Widget buildInputField(String field, String label,
        {bool isMultiline = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextFormField(
          controller: controllers.value[field],
          maxLines: isMultiline ? 3 : 1,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
          validator: (value) =>
              value?.isEmpty == true ? 'Please enter $label' : null,
        ),
      );
    }

    Widget buildDateField(String field, String label) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextFormField(
          controller: controllers.value[field],
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.grey[50],
            suffixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              controllers.value[field]?.text =
                  DateFormat('dd/MM/yyyy').format(picked);
            }
          },
          readOnly: true,
        ),
      );
    }

    Widget buildDropdownField(String field, String label, List<String> items) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: DropdownButtonFormField<String>(
          value: dropdownValues.value[field],
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: (value) {
            dropdownValues.value = {...dropdownValues.value, field: value};
          },
          validator: (value) => value == null ? 'Please select $label' : null,
        ),
      );
    }

    Widget buildSection(String title, List<Widget> children) {
      return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: children),
            ),
          ],
        ),
      );
    }

    Widget buildLeftColumn() {
      return Column(
        children: [
          buildSection(
            'Personal Information',
            [
              Row(
                children: [
                  Expanded(
                      child: buildDateField('dateOfBirth', 'Date of Birth')),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildDropdownField(
                        'gender', 'Gender', ['Male', 'Female', 'Other']),
                  ),
                ],
              ),
              buildInputField('nationality', 'Nationality'),
              Row(
                children: [
                  Expanded(
                    child: buildDropdownField('identificationType', 'ID Type',
                        ['Passport', 'Drivers License', 'ID Card']),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                      child:
                          buildInputField('identificationNumber', 'ID Number')),
                ],
              ),
            ],
          ),
          buildSection(
            'Contact Information',
            [
              buildInputField('address', 'Street Address'),
              Row(
                children: [
                  Expanded(child: buildInputField('city', 'City')),
                  const SizedBox(width: 16),
                  Expanded(child: buildInputField('state', 'State')),
                ],
              ),
              buildInputField('phoneNumber', 'Phone Number'),
            ],
          ),
        ],
      );
    }

    Widget buildRightColumn() {
      return Column(
        children: [
          buildSection(
            'Employment Details',
            [
              Row(
                children: [
                  Expanded(
                      child: buildDateField('admissionDate', 'Start Date')),
                  const SizedBox(width: 16),
                  Expanded(child: buildInputField('salary', 'Salary')),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: buildDropdownField('rolName', 'Role', [
                      'Administrator',
                      'Supervisor',
                      'Collector',
                      'Secretary'
                    ]),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildDropdownField('department', 'Department',
                        ['Sales', 'Administration', 'Route']),
                  ),
                ],
              ),
            ],
          ),
          buildSection(
            'Emergency Contact',
            [
              buildInputField('emergencyContactName', 'Contact Name'),
              Row(
                children: [
                  Expanded(
                    child: buildDropdownField(
                        'emergencyContactRelationship',
                        'Relationship',
                        ['Spouse', 'Parent', 'Sibling', 'Friend', 'Other']),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                      child: buildInputField(
                          'emergencyContactPhone', 'Contact Phone')),
                ],
              ),
              buildInputField('emergencyContactEmail', 'Contact Email'),
            ],
          ),
          buildSection(
            'Additional Information',
            [
              buildInputField('skillsAndTalents', 'Skills and Talents',
                  isMultiline: true),
              buildInputField('notes', 'Additional Notes', isMultiline: true),
            ],
          ),
        ],
      );
    }

    Widget buildProfileSection() {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: selectedImage.value != null
                              ? Image.file(
                                  selectedImage.value!,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey[400],
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.white, size: 20),
                            onPressed: pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  if (!isSmallScreen)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildInputField('firstName', 'First Name'),
                          buildInputField('lastName', 'Last Name'),
                          buildInputField('email', 'Email'),
                        ],
                      ),
                    ),
                ],
              ),
              if (isSmallScreen) ...[
                const SizedBox(height: 16),
                buildInputField('firstName', 'First Name'),
                buildInputField('lastName', 'Last Name'),
                buildInputField('email', 'Email'),
              ],
            ],
          ),
        ),
      );
    }

    Widget buildFormContent() {
      return Form(
        key: formKey.value,
        child: Column(
          children: [
            buildProfileSection(),
            const SizedBox(height: 16),
            if (isSmallScreen)
              Column(
                children: [
                  buildLeftColumn(),
                  buildRightColumn(),
                ],
              )
            else
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: buildLeftColumn()),
                    const SizedBox(width: 16),
                    Expanded(child: buildRightColumn()),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.value.currentState?.validate() ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Employee registered successfully!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Register Employee',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          controller: scrollController,
          child: buildFormContent(),
        ),
      ),
    );
  }
}
