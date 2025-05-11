import 'package:evochurch/src/widgets/loading.dart';
import 'package:evochurch/src/widgets/widget_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

// Add pages for each menu item
import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/utils/string_text_utils.dart';
import 'package:evochurch/src/view/members/widgets/personal_infomation_card.dart';
import 'package:evochurch/src/view/members/widgets/top_bar_menus.dart';
import 'package:evochurch/src/view_model/members_view_model.dart';
import '../../widgets/button/button.dart';
import '../../widgets/maintanceWidgets/maintance_widgets.dart';

class MembershipPage extends HookWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useState(GlobalKey<FormState>());
    MembersViewModel viewModel =
        Provider.of<MembersViewModel>(context, listen: false);

    final membershipTextControllers =
        useState<Map<String, TextEditingController>>({});
    final _historyControllers =
        useState<Map<String, TextEditingController>>({});
    final membershipData = useState<Map<String, dynamic>>({});

    disposeControllers() {
      for (var controller in membershipTextControllers.value.values) {
        controller.dispose();
      }
      for (var controller in _historyControllers.value.values) {
        controller.dispose();
      }
    }

    useEffect(() {
      for (var field in membershipControllers) {
        membershipTextControllers.value[field] = TextEditingController();
      }

      for (var field in historyControllers) {
        _historyControllers.value[field] = TextEditingController();
      }

      // Fetch membership data when the widget is built the first time
      getMembershipData() async {
        try {
          // Get the membership roles
          await viewModel.getMemberRoles();

          // Get the membership data and history
          membershipData.value = await viewModel.getMembershipByMemberId(
              viewModel.selectedMember!.memberId.toString());
          if (membershipData.value['membership'].isNotEmpty) {
            membershipTextControllers.value['baptismChurch']!.text =
                membershipData.value['membership'][0]['baptismChurch'];
            membershipTextControllers.value['baptismPastor']!.text =
                membershipData.value['membership'][0]['baptismPastor'];
            membershipTextControllers.value['membershipRole']!.text =
                membershipData.value['membership'][0]['membershipRole'];
            membershipTextControllers.value['baptismChurchCity']!.text =
                membershipData.value['membership'][0]['baptismChurchCity'];
            membershipTextControllers.value['baptismChurchCountry']!.text =
                membershipData.value['membership'][0]['baptismChurchCountry'];
            membershipTextControllers.value['baptismDate']!.text =
                membershipData.value['membership'][0]['baptismDate'].toString();
            membershipTextControllers.value['hasCredential']!.text =
                membershipData.value['membership'][0]['hasCredential']
                    .toString();
            membershipTextControllers.value['isBaptizedInSpirit']!.text =
                membershipData.value['membership'][0]['isBaptizedInSpirit']
                    .toString();
          }

          // return membershipData.value;
        } catch (e) {
          throw Exception('Failed to load members $e');
        }
      }

      getMembershipData();

      return () {
        disposeControllers();
      };
    }, []);

    updateMembership() async {
      try {
        if (!formKey.value.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please fill in all required fields.')));
        } else {
          final response = await viewModel.setMembershipMaintance({
            'profileId': viewModel.selectedMember!.memberId,
            'baptismDate': convertDateFormat(membershipTextControllers
                .value['baptismDate']!.text
                .toString()),
            'baptismChurch':
                membershipTextControllers.value['baptismChurch']!.text,
            'baptismPastor':
                membershipTextControllers.value['baptismPastor']!.text,
            'membershipRole':
                membershipTextControllers.value['membershipRole']!.text,
            'baptismChurchCity':
                membershipTextControllers.value['baptismChurchCity']!.text,
            'baptismChurchCountry':
                membershipTextControllers.value['baptismChurchCountry']!.text,
            'hasCredential':
                membershipTextControllers.value['hasCredential']!.text,
            'isBaptizedInSpirit':
                membershipTextControllers.value['isBaptizedInSpirit']!.text,
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
            child: Form(
          key: formKey.value,
          child: // show a loading indicator if the data is loading
              viewModel.isLoading
                  ? simpleLoadingUI(context, 'Loading data...')
                  : ListView(children: [
                      buildInformationCard('Membership Information', [
                        buildResponsiveRow([
                          buildDateField('Baptism Date', 'baptismDate', context,
                              membershipTextControllers.value),
                          buildEditableField('Baptism Church', 'baptismChurch',
                              membershipTextControllers.value)
                        ]),
                        EvoBox.h16,
                        buildResponsiveRow([
                          buildEditableField('Baptism Pastor', 'baptismPastor',
                              membershipTextControllers.value),
                          Consumer<MembersViewModel>(
                              builder: (context, viewModel, child) {
                            return buildDropdownField(
                                'Membership Role',
                                'membershipRole',
                                membershipTextControllers.value,
                                viewModel: viewModel);
                          }),
                        ]),
                        EvoBox.h16,
                        buildResponsiveRow([
                          buildEditableField(
                              'Baptism City',
                              'baptismChurchCity',
                              membershipTextControllers.value),
                          buildEditableField(
                              'Baptism Country',
                              'baptismChurchCountry',
                              membershipTextControllers.value),
                        ]),
                        EvoBox.h16,
                        buildResponsiveRow([
                          buildSwitchTile('Has Credential', 'hasCredential',
                              context, membershipTextControllers.value),
                          buildSwitchTile(
                              'Is Baptized In Spirit',
                              'isBaptizedInSpirit',
                              context,
                              membershipTextControllers.value),
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
