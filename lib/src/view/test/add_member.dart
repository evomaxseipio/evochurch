import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(MaterialApp(home: HomePage()));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Church App')),
      body: Center(
        child: ElevatedButton(
          child: Text('Add Person'),
          onPressed: () => _showAddPersonModal(context),
        ),
      ),
    );
  }

  void _showAddPersonModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: AddPersonForm(),
        );
      },
    );
  }
}

class AddPersonForm extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir persona'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildMemberInfo(),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildAddressAndOtherInfo(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          child: Text('Guardar'),
          onPressed: () {
            // TODO: Implement save functionality
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Widget _buildMemberInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.camera_alt, size: 40, color: Colors.blue),
          ),
        ),
        SizedBox(height: 16),
        _buildTextField('Primer nombre *'),
        _buildTextField('Segundo nombre'),
        _buildTextField('Apellidos *'),
        _buildTextField('Apodo'),
        _buildDateField('Fecha de nacimiento'),
        _buildGenderRadio(),
        _buildTextField('Grupos'),
        _buildTextField('Título del cargo'),
        _buildTextField('Empleador'),
        _buildTextField('Talentos y pasatiempos'),
        _buildDropdown('Estado civil', ['Desconocido']),
        _buildDateField('Fecha de incorporación'),
        SizedBox(height: 16),
        Text('Información de bautismo',
            style: TextStyle(fontWeight: FontWeight.bold)),
        _buildDateField('Fecha del bautismo'),
        _buildTextField('Lugar del bautismo'),
      ],
    );
  }

  Widget _buildAddressAndOtherInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dirección', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildTextField('Línea de dirección'),
        _buildDropdown('Provincia', []),
        _buildTextField('Ciudad'),
        _buildTextField('Código postal'),
        SizedBox(height: 16),
        Text('Contacto', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildTextField('Número de sobre'),
        _buildTextField('Teléfono móvil'),
        _buildCheckbox('No enviar mensajes de texto'),
        _buildTextField('Teléfono de casa'),
        _buildTextField('Correo electrónico'),
        _buildCheckbox('No enviar correo electrónico'),
        SizedBox(height: 16),
        Text('Educación', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildTextField('Escuela'),
        _buildDropdown('Grado', ['Desconocido']),
        _buildDropdown('Estado', ['Desconocido']),
        SizedBox(height: 16),
        Text('Miembros de la familia',
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ElevatedButton.icon(
          icon: Icon(Icons.person_add),
          label: Text('Persona existente'),
          onPressed: () {},
        ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          icon: Icon(Icons.person_add),
          label: Text('Nueva persona'),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDateField(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () {
          // TODO: Implement date picker
        },
      ),
    );
  }

  Widget _buildGenderRadio() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: RadioListTile<String>(
              title: Text('Masculino'),
              value: 'Masculino',
              groupValue: null,
              onChanged: (value) {},
            ),
          ),
          Expanded(
            child: RadioListTile<String>(
              title: Text('Femenino'),
              value: 'Femenino',
              groupValue: null,
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildCheckbox(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Checkbox(value: false, onChanged: (value) {}),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
