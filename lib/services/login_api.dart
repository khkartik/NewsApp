// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:river_pod/view_models/login_api_model.dart';

class LoginApi {
  final apiKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im10ZWlxdG9ycnpudG56bXdxZ2JjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE5MTI0OTEsImV4cCI6MjA2NzQ4ODQ5MX0.deyfTgMLcLdSsLpwT1uVYP5hlSb-9wSU_w_EzAW08cA";

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://mteiqtorrzntnzmwqgbc.supabase.co/rest/v1/",
      headers: {
        "apikey":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im10ZWlxdG9ycnpudG56bXdxZ2JjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE5MTI0OTEsImV4cCI6MjA2NzQ4ODQ5MX0.deyfTgMLcLdSsLpwT1uVYP5hlSb-9wSU_w_EzAW08cA",
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im10ZWlxdG9ycnpudG56bXdxZ2JjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE5MTI0OTEsImV4cCI6MjA2NzQ4ODQ5MX0.deyfTgMLcLdSsLpwT1uVYP5hlSb-9wSU_w_EzAW08cA",
        "Content-Type": "application/json",
      },
    ),
  );

  Future<List<AccountModel>> allAccounts() async {
    try {
      final response = await dio.get("login?select=*");

      if (response.statusCode == 200) {
        final data = response.data as List;
        final accounts =
            data.map((json) => AccountModel.fromJson(json)).toList();
        print("✅ Total accounts: ${accounts.length}");
        return accounts;
      } else {
        print("❌ Request failed: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("⚠️ Error: $e");
      return [];
    }
  }

  Future<AccountModel?> addAccount({
    required String name,
    required String email,
    required String uid,
  }) async {
    try {
      final response = await dio.post(
        "login",
        options: Options(headers: {"Prefer": "return=representation"}),
        data: {"name": name, "email": email, "uid": uid},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final json = (response.data as List).first;
        final account = AccountModel.fromJson(json);
        print("✅ Account added: ${account.name}");
        return account;
      } else {
        print("❌ Failed to add account: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error: $e");
      return null;
    }
  }
}
