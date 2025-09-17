import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod/services/api.dart';
import 'package:river_pod/services/login_api.dart';
import 'package:river_pod/view_models/login_api_model.dart';
import 'package:river_pod/view_models/news_model.dart';

final apiProvider = Provider<Api>((ref) => Api());

final searchProvider = StateProvider<String>((ref) => "keyword");

final newsProvider = FutureProvider<List<Article>>((ref) async {
  final api = ref.read(apiProvider);
  final search = ref.watch(searchProvider);
  return api.searchNews(search);
});

final loginApiProvider = Provider<LoginApi>((ref) => LoginApi());

final accountsProvider = FutureProvider<List<AccountModel>>((ref) async {
  final api = ref.read(loginApiProvider);
  return api.allAccounts();
});

final nameProvider = StateProvider<String>((ref) => "");
final emailProvider = StateProvider<String>((ref) => "");
final uidProvider = StateProvider<String>((ref) => "");

final addAccountProvider =
    FutureProvider.family<AccountModel?, Map<String, String>>((
      ref,
      data,
    ) async {
      final api = ref.read(loginApiProvider);
      return api.addAccount(
        name: data['name']!,
        email: data['email']!,
        uid: data['uid']!,
      );
    });

final currentAccountProvider = StateProvider<AccountModel?>((ref) => null);
