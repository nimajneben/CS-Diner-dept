import 'package:path_provider/path_provider.dart';

Future<String> get _localpath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}
