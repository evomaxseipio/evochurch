

 import 'package:evochurch/src/constants/constant_index.dart';
import 'package:flutter/material.dart';

final List<Map<String, dynamic>> chartTitle = [
  {
    "title": "Ganancias Brutas",
    "color": EvoColor.primary,
    "amount_total": "\$21,720.00",
  },
  {
    "title": "Total Gastos",
    "color": EvoColor.errorDark,
    "amount_total": "\$12,000.00",
  },
];
final List<Map<String, dynamic>> pieChartTitle = [
  {
    "title": "Atrasos",
    "color": EvoColor.redDark,
  },
  {
    "title": "Adelantos",
    "color": EvoColor.blueDarkChartColor,
  },
  {
    "title": "Moras",
    "color": const Color.fromARGB(255, 126, 1, 143),
  },
  {
    "title": "Vencidos",
    "color": EvoColor.black,
  },
];


final List<Map<String, dynamic>> earningAndTotalListItem = [
  {
    'id': 0,
    'producTitle': 'Ganacias del Dia',
    'value': '\$21,720.00',
  },
  {
    'id': 1,
    'producTitle': 'Gastos del Dia',
    'value': '\$12,000.00',
  },
  // {
  //   'id': 2,
  //   'producTitle': 'Gross Sales',
  //   'value': '1200',
  // },
  // {
  //   'id': 3,
  //   'producTitle': 'Total Engaged Users',
  //   'value': '2000',
  // },
];

final List<Map<String, dynamic>> newCustomerContract = [
  
        {
            "church_id": 1,
            "collection_id": "8c728002-5283-49c5-899f-63b7d09ebb39",
            "collection_type": 1,
            "collection_type_name": "Diezmos",
            "collection_date": "2025-03-03",
            "collection_amount": 1000.00,
            "is_anonymous": false,
            "payment_method": "Cash",
            "comments": "Diezmo",
            "is_active": true,
            "fund_id": "b098e877-6f40-4fc1-b9de-80e90fd31141"
        },
        {
            "church_id": 1,
            "collection_id": "1c1c5e37-9dba-4180-ba7c-6860c99c9a0a",
            "collection_type": 2,
            "collection_type_name": "Ofrendas",
            "collection_date": "2025-02-26",
            "collection_amount": 10000.00,
            "is_anonymous": false,
            "payment_method": "",
            "comments": "prueba ofrenda",
            "is_active": true,
            "fund_id": "af120df8-dcd8-480b-8410-d32002821725"
        },
        {
            "church_id": 1,
            "collection_id": "6856fe4e-3fe1-45b0-978e-258c1a56094c",
            "collection_type": 1,
            "collection_type_name": "Diezmos",
            "collection_date": "2025-02-25",
            "collection_amount": 1100.00,
            "is_anonymous": false,
            "payment_method": "",
            "comments": "test",
            "is_active": true,
            "fund_id": "b098e877-6f40-4fc1-b9de-80e90fd31141"
        },
        {
            "church_id": 1,
            "collection_id": "3b3faf34-e9ab-4132-a725-16eda8aa241a",
            "collection_type": 1,
            "collection_type_name": "Diezmos",
            "collection_date": "2025-02-25",
            "collection_amount": 1400.00,
            "is_anonymous": false,
            "payment_method": "",
            "comments": "test",
            "is_active": true,
            "fund_id": "b098e877-6f40-4fc1-b9de-80e90fd31141"
        },
        {
            "church_id": 1,
            "collection_id": "5c40ce9f-aab3-4ccf-b54a-6c4ee8f8276a",
            "collection_type": 3,
            "collection_type_name": "Donaciones",
            "collection_date": "2025-02-20",
            "collection_amount": 50000.00,
            "is_anonymous": false,
            "payment_method": "Cash",
            "comments": "Primera donacion de prueba",
            "is_active": true,
            "fund_id": "af120df8-dcd8-480b-8410-d32002821725"
        },
        {
            "church_id": 1,
            "collection_id": "99c8a719-0de0-4ac9-9dd7-0c066805e559",
            "collection_type": 2,
            "collection_type_name": "Ofrendas",
            "collection_date": "2025-01-14",
            "collection_amount": 4000.00,
            "is_anonymous": false,
            "payment_method": "Cash",
            "comments": "testing",
            "is_active": true,
            "fund_id": "587d8458-b999-4a65-8ae5-d7209aa811b2"
        }
 
];
