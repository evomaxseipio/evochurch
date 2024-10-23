// Add pages for each menu item
import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/view/members/personal_information.dart';
import 'package:evochurch/src/view/members/widgets/personal_infomation_card.dart';
import 'package:evochurch/src/view/members/widgets/top_bar_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../widgets/button/button.dart';
import '../../widgets/maintanceWidgets/maintance_widgets.dart';

class MembershipPage extends HookWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useState(GlobalKey<FormState>());
    final _membershipControllers =
        useState<Map<String, TextEditingController>>({});
    final _historyControllers =
        useState<Map<String, TextEditingController>>({});

    useEffect(() {
      for (var field in membershipControllers) {
        _membershipControllers.value[field] = TextEditingController();
      }

      for (var field in historyControllers) {
        _historyControllers.value[field] = TextEditingController();
      }

      return () {
        for (var controller in _membershipControllers.value.values) {
          controller.dispose();
        }
        for (var controller in _historyControllers.value.values) {
          controller.dispose();
        }
      };
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MemberTopMenu(
          onUpdate: () {},
          onPrint: () {},
        ),
        EvoBox.h16,
        Expanded(
            child: Card(
          elevation: 2,
          child: ListView(children: [
            InformationCard(title: 'Membership Information', children: [
              Row(children: [
                Expanded(
                    child: buildEditableField('Baptism Date', 'baptismDate',
                        _membershipControllers.value)),
                EvoBox.w16,
                Expanded(
                    child: buildEditableField('Baptism Church', 'baptismChurch',
                        _membershipControllers.value)),
              ]),
              EvoBox.h16,
              Row(children: [
                Expanded(
                    child: buildEditableField('Baptism Pastor', 'baptismPastor',
                        _membershipControllers.value)),
                EvoBox.w10,
                Expanded(
                    child: buildDropdownField('Membership Role',
                        'membershipRole', _membershipControllers.value)),
              ]),
            ]),
            EvoBox.h16,
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'History Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        EvoButton(
                          icon: const Icon(Icons.post_add_rounded),
                          onPressed: () {},
                          text: 'Add History',
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                    EvoBox.h16,
                  ],
                ),
              ),
            ),
          ]),
        ))
      ],
    );
  }
}
