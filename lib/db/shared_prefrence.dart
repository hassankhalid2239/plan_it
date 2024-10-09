import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  // var theme;
  void setData(bool theme) async {
    var ref = await SharedPreferences.getInstance();
    ref.setBool('theme', theme);
  }

  Future<bool?> isTheme() async {
    var re = await SharedPreferences.getInstance();
    return re.getBool('theme');
  }
}
