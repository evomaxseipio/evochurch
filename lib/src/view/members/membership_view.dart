// Add pages for each menu item
import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/utils/string_text_utils.dart';
import 'package:evochurch/src/view/members/personal_information.dart';
import 'package:evochurch/src/view/members/widgets/personal_infomation_card.dart';
import 'package:evochurch/src/view/members/widgets/top_bar_menus.dart';
import 'package:evochurch/src/view_model/members_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../widgets/button/button.dart';
import '../../widgets/maintanceWidgets/maintance_widgets.dart';

class MembershipPage extends HookWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    MembersViewModel viewModel = Provider.of<MembersViewModel>(context, listen: false);
    final formKey = useState(GlobalKey<FormState>());
    final membershipTextControllers = useState<Map<String, TextEditingController>>({});
    final _historyControllers = useState<Map<String, TextEditingController>>({});
    context.read<MembersViewModel>().getMemberRoles();

    useEffect(() {
      for (var field in membershipControllers) {
        membershipTextControllers.value[field] = TextEditingController();
      }

      for (var field in historyControllers) {
        _historyControllers.value[field] = TextEditingController();
      }

      return () {
        for (var controller in membershipTextControllers.value.values) {
          controller.dispose();
        }
        for (var controller in _historyControllers.value.values) {
          controller.dispose();
        }
      };
    });

    updateMembership() async {
      try {

        if (!formKey.value.currentState!.validate()) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please fill in all required fields.')));
        } else {
          final response = await viewModel.setMembershipMaintance({
            'profileId': viewModel.selectedMember!.memberId,
            'baptismDate': convertDateFormat(membershipTextControllers.value['baptismDate']!.text),
            'baptismChurch': membershipTextControllers.value['baptismChurch']!.text,
            'baptismPastor':membershipTextControllers.value['baptismPastor']!.text,
            'membershipRole': membershipTextControllers.value['membershipRole']!.text,
            'baptismChurchCity': membershipTextControllers.value['baptismChurchCity']!.text,
            'baptismChurchCountry': membershipTextControllers.value['baptismChurchCountry']!.text,
          });

          if (!context.mounted) return;
          if (response['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Membership updated successfully')),
            );
          } else {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${response['message']}')),
            );
          }
          formKey.value.currentState!.save();
        }
        
      } catch (e) {
         throw Exception('Failed to load members $e');
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MemberTopMenu(
            onUpdate: updateMembership, onPrint: viewModel.getMemberRoles),
        EvoBox.h16,
        Expanded(
            child: Card(
          elevation: 2,
          child: Form(
            key: formKey.value,
            child: ListView(children: [
              InformationCard(title: 'Membership Information', children: [
                Row(children: [
                  Expanded(
                      child: buildDateField('Baptism Date', 'baptismDate',
                          context, membershipTextControllers.value)),
                  EvoBox.w16,
                  Expanded(
                      child: buildEditableField('Baptism Church', 'baptismChurch',
                          membershipTextControllers.value)),
                ]),
                EvoBox.h16,
                Row(children: [
                  Expanded(
                      child: buildEditableField('Baptism Pastor', 'baptismPastor',
                          membershipTextControllers.value)),
                  EvoBox.w10,
                  Expanded(child: Consumer<MembersViewModel>(
                      builder: (context, viewModel, child) {
                    return buildDropdownField('Membership Role', 'membershipRole',
                        membershipTextControllers.value,
                        viewModel: viewModel);
                  })),
                ]),
                EvoBox.h16,
                Row(children: [
                  Expanded(
                      child: buildEditableField('Baptism City',
                          'baptismChurchCity', membershipTextControllers.value)),
                  EvoBox.w10,
                  Expanded(
                      child: buildEditableField(
                          'Baptism Country',
                          'baptismChurchCountry',
                          membershipTextControllers.value)),
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
          ),
        ))
      ],
    );
  }
}
