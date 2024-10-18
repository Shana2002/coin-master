import 'package:dio/dio.dart';
import '../model/app_config.dart';
import 'package:get_it/get_it.dart';

class HttpService {
  final Dio dio = Dio();
  AppConfig? _appConfig;
  String? base_url;

  HttpService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    base_url = _appConfig!.base_url;
  }
  Future<Response?> get(String _path) async {
    try {
      String url = "$base_url$_path";
      Response response = await dio.get(url);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
