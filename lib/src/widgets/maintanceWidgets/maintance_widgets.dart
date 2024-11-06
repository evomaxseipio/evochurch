import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/view_model/members_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../text/evo_custom_text_field.dart';

final Map<String, String?> _dropdownValues = {};
// Side Bar Items
Widget buildSidebarItem(String title, String selectedItem, IconData icon,
    {required VoidCallback onTap, bool isDestructive = false}) {
  final isActive = title == selectedItem;

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isActive ? Colors.blue[100] : Colors.transparent,
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center, // Center text
          children: [
            isDestructive
                ? Icon(icon, size: 20, color: Colors.red)
                : Icon(
                    icon,
                    color: isActive
                        ? const Color.fromARGB(255, 18, 67, 152)
                        : Colors.grey.shade400,
                    size: isActive ? 23 : 20,
                  ),
            const SizedBox(width: 8), // Space between icon and text
            Text(
              title,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
                color: isDestructive
                    ? Colors.red
                    : isActive
                        ? const Color.fromARGB(255, 18, 67, 152)
                        : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class FormEditableField extends StatelessWidget {
  final String label;
  final String? value;

  const FormEditableField({
    super.key,
    required this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value!,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

String splitCamelCase(String input) {
  return input.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'), (Match m) => '${m[1]} ${m[2]}');
}

Widget buildEditableField(
  String label,
  String field,
  Map<String, TextEditingController> controllers,{
  bool isRequired = true,
}
) {
  // Add null check and debug information
  final controller = controllers[field];
  if (controller == null) {
    return const SizedBox.shrink(); // Return empty widget if controller not found
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        (splitCamelCase(label.capitalize)),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      EvoCustomTextField(
        // labelText: label,
        controller: controllers[field],
        validator: isRequired
            ? (value) {
          if (value?.isEmpty == true) {
            return 'Please enter $label';
          }

          if (field == 'email' &&
              !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
            return 'Please enter a valid email address';
          }

          return null;
        } : null,
      ),
    ],
  );
}

Widget buildDateField(String label, String field, BuildContext context,
    Map<String, TextEditingController> controllers, {bool isRequired = true}) {
  // Verify is field is null and add the today
  if (controllers[field] == null || controllers[field]!.text.isEmpty) {
    controllers[field] = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
  } else {
    controllers[field] =
        TextEditingController(text: formatDate(controllers[field]!.text));
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        splitCamelCase(label.capitalize),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: EvoCustomTextField(
          controller: controllers[field] ?? TextEditingController(),
          suffixIcon: const Icon(Icons.calendar_today),
          validator: isRequired
              ? (value) => value?.isEmpty == true
                ? 'Please enter ${splitCamelCase(label.capitalize)}'
                : null
              : null,
          onTap: () async {
            DateTime initialDate;
            try {
              initialDate = controllers[field]?.text.isNotEmpty == true
                  ? DateFormat('dd/MM/yyyy').parse(controllers[field]!.text)
                  : DateTime.now();
            } catch (e) {
              initialDate = DateTime.now();
            }

            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              controllers[field]?.text =
                  DateFormat('dd/MM/yyyy').format(pickedDate);
            }
            debugPrint(controllers[field]?.text);
          },
          readOnly: true,
        ),
      ),
    ],
  );
}

Widget buildDropdownField(String label, String field,
    Map<String, TextEditingController> controllers, {MembersViewModel? viewModel, bool isRequired = true}) {
  // final theme = Theme.of(context);

  String? initialValue = controllers[field]?.text.isNotEmpty == true
      ? controllers[field]?.text
      : _dropdownValues[field];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        (splitCamelCase(label).capitalize),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      // const SizedBox(height: 4),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: StatefulBuilder(
            builder: (context, setState) => DropdownButtonFormField<String>(
              value: initialValue ?? _dropdownValues[field],
              // isExpanded: true,
              isDense: true,
              hint: Text('Select $label'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                suffixIconConstraints: const BoxConstraints(minWidth: 30),              
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                errorStyle: TextStyle(fontSize: 14, height: 0.7, color: Colors.red),
              ),
              items: _getDropdownItems(field, viewModel: viewModel)
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  _dropdownValues[field] = value;
                  controllers[field]!.text = value;
                  setState(() => _dropdownValues[field] = value);
                }
              },
              validator: isRequired
                  ? (value) =>
                    value == null ? 'Please select ${splitCamelCase(label.capitalize)}': null
                  : null,
            ),
          )),
    ],
  );
}

List<String> _getDropdownItems(String field, {MembersViewModel? viewModel})  {
  // Initialize the membershipRoles list
  List<String> membershipRoles = [];

  // Get the data from database in case field is membershipRole
  if (field == 'membershipRole') {
    membershipRoles = viewModel!.memberRoles;
  }

  if (field == 'gender') {
    return ['Male', 'Female'];
  } else if (field == 'identificationType') {
    return ['passport', 'idCard'];
  } else if (field == 'maritalStatus') {
    return ['Single', 'Married', 'Divorced', 'Widowed'];
  } else if (field == 'idType') {
    return ['Passport', 'ID Card', 'Drivers License'];
  } else if (field == 'isMember') {
    return ['Active Member', 'Not a Member'];
  } else if (field == 'isActive') {
    return ['Active', 'Inactive'];
  } else if (field == 'country') {
    return [
      'Republica Dominicana',
      'Haiti',
      'Guatemala',
      'Venezuela',
      'United States',
      'Canada',
      'Mexico'
    ];
  } else if (field == 'membershipRole') {
    return membershipRoles;
  } else {
    return [];
  }
}
