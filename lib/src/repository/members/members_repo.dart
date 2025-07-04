import '../../model/member_model.dart';

class MembersRepo {
  Future<List<Member>> fetchMembers() async {
    // Aquí va la lógica real de acceso a datos (API, Supabase, etc)
    // Ejemplo:
    // final response = await api.get('/members');
    // return response.map((json) => Member.fromJson(json)).toList();
    return [];
  }

  Future<void> addMember(Member member) async {
    // Lógica para agregar miembro
  }

  Future<void> updateMember(Member member) async {
    // Lógica para actualizar miembro
  }

  Future<void> deleteMember(String memberId) async {
    // Lógica para eliminar miembro
  }
}
