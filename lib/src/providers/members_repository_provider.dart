import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../repository/members/members_repo.dart';

final membersRepositoryProvider = Provider<MembersRepo>((ref) {
  return MembersRepo();
});
