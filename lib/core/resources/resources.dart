import '../theme/theme.dart';

class Resources {
  const Resources();

  AppColors get colors {
    return AppColors();
  }

  BaseStyles get styles {
    return AppStyles(colors);
  }
}
