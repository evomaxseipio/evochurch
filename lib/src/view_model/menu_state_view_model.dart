import 'package:flutter/foundation.dart';
import 'package:nb_utils/nb_utils.dart';

class MenuStateProvider extends ChangeNotifier {
  String? _expandedGroup;
  bool _isChild = false;

  String? get expandedGroup => _expandedGroup;
  bool get isChild => _isChild;

  set isChild(bool value) {
    _isChild = value;
    notifyListeners();
  }
  

  // Constructor
  MenuStateProvider() {
    // Load the group from shared preferences
    getGroupSharedPreference().then((value) {
      _expandedGroup = value;
      notifyListeners();
    });
  }
 

  void toggleGroup(String groupName) {
    if (_expandedGroup == groupName) {
      _expandedGroup = null;
    } else {
      _expandedGroup = groupName;
    }
    notifyListeners();
  }

  void setGroup(String? groupName) {
    _expandedGroup = groupName;
    setGroupSharedPreference(groupName);
    notifyListeners();
  }

  // resets the group to default state

  void resetGroup() {
    _expandedGroup = null;
    setGroupSharedPreference(null);
    notifyListeners();
  }

  

  // sets the group with sharedpreference
  void setGroupSharedPreference(String? groupName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('expandedGroup', groupName ?? '');
  }

  // gets the group from sharedpreference
  Future<String?> getGroupSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('expandedGroup');
  }

  // clears the group from shared preference
  void clearGroup() {
    _expandedGroup = null;
    setGroupSharedPreference(null);
    notifyListeners();
  }
}


