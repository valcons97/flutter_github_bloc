import 'package:deall/utils/lib/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// For configuration related to dependency injection framework
class DiConfig {
  static final enableDummyRepos = dotenv.getBool(
    'ENABLE_DUMMY_REPOS',
    fallback: true,
  );
}
