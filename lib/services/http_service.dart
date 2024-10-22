import 'package:http/http.dart' as http;
import '../model/app_config.dart';
import 'package:get_it/get_it.dart';

class HttpService {
  AppConfig? _appConfig;
  String? baseUrl;

  HttpService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    baseUrl = _appConfig!.base_url;
  }

  Future<http.Response?> get(String _path) async {
    try {
      String url = "$baseUrl$_path";
      Map<String, String> headers = {
        "accept":"application/json",
      };
      final response = await http.get(Uri.parse(url), headers: headers);

      print(response.statusCode);

      if (response.statusCode == 200) {
        return response;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
