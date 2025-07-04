import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../model/member_model.dart';
import 'members_repository_provider.dart';

final membersProvider = FutureProvider<List<Member>>((ref) async {
  final repo = ref.watch(membersRepositoryProvider);
  return repo.fetchMembers();
});
