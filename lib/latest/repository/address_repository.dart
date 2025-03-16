import 'dart:convert';
import 'package:demo_app/latest/models/address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressRepository {
  static const String _key = "addresses";
  final SharedPreferences _prefs; // ✅ Store instance

  AddressRepository(this._prefs);

  Future<List<AddressModel>> getAddresses() async {
    final data = _prefs.getString(_key);
    if (data == null) return [];
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => AddressModel.fromJson(json)).toList();
  }

  Future<void> saveAddresses(List<AddressModel> addresses) async {
    try {
      final jsonList = addresses.map((addr) => addr.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await _prefs.setString(_key, jsonString);
    } catch (e, stackTrace) {
      print("Stack trace: $stackTrace");
    }
  }
}
